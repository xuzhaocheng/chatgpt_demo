//
//  ChatThreadChatGPTActions.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Combine
import OSLog

class ChatThreadChatGPTActions: ChatThreadViewModelActions {
    private var lastUserMessgeSentId: String?
    
    var chatThread: ChatThreadModel

    private var createChatGPTThreadObserver: AnyCancellable? = nil
    private var trainingMessageObserver: AnyCancellable? = nil
    private var loadMessageObserver: AnyCancellable? = nil
    private var sendMessageObserver: AnyCancellable? = nil
    private var pollRunObserver: AnyCancellable? = nil
    private var queryNextMessagesObserver: AnyCancellable? = nil
    private weak var delegate: ChatThreadViewModelActionsDelegate?
    
    init(chatThread: ChatThreadModel, delegate: ChatThreadViewModelActionsDelegate) {
        self.chatThread = chatThread
        self.delegate = delegate
    }
    
    func loadThread() -> Future<ChatThreadModel, Error> {
        Future<ChatThreadModel, Error> { promixe in            
            guard self.chatThread.chatgptThreadId != nil,
                  self.chatThread.chatgptThreadId! != "" else {
                self._createChatGPTThread { result in
                    switch result {
                    case .success(_):
                        if self.chatThread.listing?.assistantId == nil {
                            // Tell ChatGPT to tell it to be an assistant to current listing
                            let trainingMessage = ChatGPTHTTPClient.shared.trainingMessage(chatThread: self.chatThread, chatgptThreadId: self.chatThread.chatgptThreadId!)
                            Logger.system.infoAndCache("Sending training message: \(trainingMessage)")

                            self.sendMessage(shouldAddToMessageList: false, chatThread: self.chatThread, sender: MockDataHelper.selfContact, message: trainingMessage)
                            promixe(.success(self.chatThread))
                        } else {
                            // This is the case where we have a specific assistant for this AirBnb listing, we don't need to send
                            // any training messages since this assistant already has all the listing data
                            ChatGPTHTTPClient.shared.triggerAssistantRun(chatThread: self.chatThread, chatgptThreadId: self.chatThread.chatgptThreadId!) { assistantRunResult in
                                switch assistantRunResult {
                                case .success(let chatGPTAssistantRunResponse):
                                    promixe(.success(self.chatThread))
                                    
                                    // Start Polling run
                                    self.delegate?.appendMessage(message: MockDataHelper.airGPTPlaceholderMessage(chatThread: self.chatThread))
                                    self._pollRunObserver(chatGPTMessagesPostResponse: nil, chatGPTAssistantRunResponse: chatGPTAssistantRunResponse)
                                case .failure(let error):
                                    promixe(.failure(error))
                                    self.delegate?.addFailureMessage()
                                }
                            }
                        }
                    case .failure(let error):
                        promixe(.failure(error))
                        self.delegate?.addFailureMessage()
                    }
                }
                return
            }
            
            self._loadNextMessages(messageId: nil, includeRoles: ["assistant", "user"])
            promixe(.success(self.chatThread))
        }
    }
    
    private func _createChatGPTThread(_ completion: @escaping (Result<ChatThreadModel, Error>) -> Void) {
        createChatGPTThreadObserver = ChatGPTHTTPClient.shared.createChatGPTThread()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    Logger.system.infoAndCache("Create ChatGPTThread Complete")
                case .failure(let error):
                    Logger.system.errorAndCache("Create ChatGPTThread Failed: \(error)")
                    completion(.failure(error))
                    self.delegate?.addFailureMessage()
                }
            }, receiveValue: { chatGPTThreadCreateResponse in
                self.chatThread = self.chatThread.updateChatGPTThreadId(chatGPTThreadCreateResponse.id)
                ChatThreadDataManager.shared.addCachedChatGPTThreadId(listingId: self.chatThread.listing!.id, chatGPTThreadId: chatGPTThreadCreateResponse.id)
                completion(.success(self.chatThread))
            })
    }
    
    private func _loadMessages(_ chatThread: ChatThreadModel) {
        _loadNextMessages(messageId: nil, includeRoles: ["assistant", "user"])
    }
    
    func sendMessage(shouldAddToMessageList: Bool = true, chatThread: ChatThreadModel, sender: Contact, message: String) {
        guard let threadId = self.chatThread.chatgptThreadId else {
            return
        }
        
        let newMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: sender, message: message, chatThread: self.chatThread)
        
        if shouldAddToMessageList {
            self.delegate?.appendMessage(message: newMessage)
        }
        
        sendMessageObserver = ChatGPTHTTPClient.shared.sendMessage(chatThread: chatThread, chatgptThreadId: threadId, prompt: message)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.system.infoAndCache("Send Message Complete")
                case .failure(let error):
                    Logger.system.errorAndCache("Send Message Failed \(error)")
                    self.delegate?.addFailureMessage()
                }
            }, receiveValue: { (chatGPTMessagesPostResponse, chatGPTAssistantRunResponse) in
                Logger.system.infoAndCache("Successfully sent messsage: \(chatGPTMessagesPostResponse.id)")
                self.lastUserMessgeSentId = chatGPTMessagesPostResponse.id
                
                if chatGPTAssistantRunResponse.status != "completed" {
                    self.delegate?.appendMessage(message: MockDataHelper.airGPTPlaceholderMessage(chatThread: chatThread))
                }
                
                // Start Polling run
                self._pollRunObserver(chatGPTMessagesPostResponse: chatGPTMessagesPostResponse, chatGPTAssistantRunResponse: chatGPTAssistantRunResponse)
            })
    }
    
    private func _pollRunObserver(chatGPTMessagesPostResponse: ChatGPTMessagesPostResponse?, chatGPTAssistantRunResponse: ChatGPTAssistantRunResponse) {
        Logger.system.infoAndCache("Polling run \(chatGPTAssistantRunResponse.id)")
        self.pollRunObserver = ChatGPTHTTPClient.shared.pollRun(chatgptThreadId: chatGPTAssistantRunResponse.thread_id, runId: chatGPTAssistantRunResponse.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.system.infoAndCache("Polling run finished")
                case .failure(let error):
                    Logger.system.errorAndCache("Polling run failed \(error)")
                    self.delegate?.addFailureMessage()
                }
            }, receiveValue: { chatGPTAssistantRunResponse in
                Logger.system.infoAndCache("Polling run completed with status: \(chatGPTAssistantRunResponse.status)")
                if let messageResponse = chatGPTMessagesPostResponse {
                    // load all after response
                    self._loadNextMessages(messageId: messageResponse.id)
                } else {
                    // load all messages
                    self._loadNextMessages(messageId: nil, includeRoles: ["assistant", "user"])
                }
            })
    }
    
    private func _loadNextMessages(messageId: String?, includeRoles: [String] = ["assistant"]) {
        self.queryNextMessagesObserver = ChatGPTHTTPClient.shared.queryNextMessages(chatgptThreadId: self.chatThread.chatgptThreadId!, messageId: messageId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.system.infoAndCache("Getting messages complete")
                case .failure(let error):
                    Logger.system.errorAndCache("Getting messages failed: \(error)")
                    self.delegate?.addFailureMessage()
                    
                }
            }, receiveValue: { chatGPTMessageListResponse in
                self._loadChatGPTMessages(chatGPTMessageListResponse, includeRoles: includeRoles)
            })
    }
    
    private func _loadChatGPTMessages(_ chatGPTMessageListResponse: ChatGPTMessageListResponse, includeRoles: [String]) {
        guard let messages = chatGPTMessageListResponse.data else {
            return
        }
        
        self.delegate?.removeAllPlaceholderMessages()
        
        for (index, m) in messages.enumerated() {
            guard includeRoles.contains(m.role),
                  m.content.count > 0 else {
                continue
            }
            
            if index == 0 && m.role == "user" && m.id == chatGPTMessageListResponse.first_id {
                continue // HACK for demo purposes to not show the first user message, since this first message is the training prompt
            }
            
            let contact = m.role == "user" ? MockDataHelper.selfContact : MockDataHelper.airGPTContact
            
            let chatMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: contact, message: m.content.first!.text.value, chatThread: chatThread)
            self.delegate?.appendMessage(message: chatMessage)
        }
    }
}
