require: utils/utils.js

#patterns:
#    $hello = (салют|привет|здравствуй*|здарова|добрый (день|вечер) | *start)
    
theme: /

    state: Fallback
        event!: noMatch
        script:
            $response.replies = $response.replies || [];
            $response.replies.push({
                type: 'raw',
                body: {
                    pronounceText: "Я не понимаю: {{$parseTree.text}}",
                    items: [
                        {
                            command: {
                                type: "smart_app_data",
                                smart_app_data: {
                                    type: "app_action",
                                    message: "Я не понимаю: {{$parseTree.text}}"
                                },
                            },
                            auto_listening: true
                        },
                    ],
                },
            });
        
    state: runApp
        event!: runApp
        q!: * *start
        script:
            $response.replies = $response.replies || [];
            $response.replies.push({
                type: 'raw',
                body: {
                    items: [
                        {
                            command: {
                                type: "smart_app_data",
                                smart_app_data: {
                                    type: "app_action",
                                    message: "запустиприложение"
                                },
                            },
                            auto_listening: true
                        },
                    ],
                },
            });
        
    state: addMovie
        intent!: /addMovie
        script:
            $jsapi.log("LOG of state")
            $jsapi.log(JSON.stringify($request.rawRequest))
            var film = $parseTree._film
            $jsapi.log(film)
            var routingState = $request.rawRequest.payload.meta.current_app.state
            if (routingState == "create") {
                reply( {
                        "pronounceText": film + " добавили в выборку",
                        items: [ 
                            formAddFilmCommand(film) 
                        ]
                },
                $response);
            } else {
                sendAnswer_Speech("Не получится, мы не на той странице");
            }

    state: startSession
        intent!: /startSession
        script: 
            var routingState = $request.rawRequest.payload.meta.current_app.state
            if (routingState == "create") {
                reply( {
                        "pronounceText": "Сессия была открыта: просканируйте QR-код для голосования на мобильных устройствах",
                        items: [ 
                            formStartSessionCommand() 
                        ]
                    },
                    $response);
            } else {
                sendAnswer_Speech("Не получится, мы не на той странице");
            }
            
                    
    state: endSession
        intent!: /endSession
        script:
            var routingState = $request.rawRequest.payload.meta.current_app.state
            if (routingState == "session") {
                reply( {
                        "pronounceText": "Хорошо, результаты голосования перед вами на экране",
                        items: [ 
                            formCloseSessionCommand() 
                        ]
                    },
                    $response);
            } else {
                sendAnswer_Speech("Не получится, мы не на той странице");
            }

    state: returnCreate
        intent!: /returnCreate
        script:
            var routingState = $request.rawRequest.payload.meta.current_app.state
            if (routingState != "create") {
                reply( {
                        "pronounceText": "Хорошо, вот главная страница",
                        items: [ 
                            formReturnCreateCommand() 
                        ]
                    },
                    $response);
            } else {
                sendAnswer_Speech("Мы и так тут");
            }
            
          