require: utils/utils.js

patterns:
    $hello = (салют|старт|привет|здравствуй*|здарова|добрый (день|вечер) | *start)
    $AnyText = *
    
theme: /

    state: Fallback
        event!: noMatch
        script:
            $response.replies = $response.replies || [];
            $response.replies.push({
                type: 'raw',
                body: {
                    pronounceText: "Извините, я вас не понимаю: попробуйте сказать помощь, чтобы узнать доступные команды",
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
        q!: (запусти | вруби | открой) movie (меч | match | mage)
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
        q!: (добавить|добавь|внеси|запиши|фильм|кино|кинокартина|картина)
            [фильм/кино/кинокартину/картину] 
            $AnyText::film
        script:
            var film = $parseTree._film
            var routingState = $request.rawRequest.payload.meta.current_app.state.routingState
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
            $jsapi.log("startsession")
            var routingState = $request.rawRequest.payload.meta.current_app.state.routingState
            if (routingState == "create") {
                reply( {
                        "pronounceText": "Сессия была открыта: просканируйте QR-код для голосования на мобильных устройствах",
                        items: [ 
                            formOpenSessionCommand() 
                        ]
                    },
                    $response);
            } else {
                sendAnswer_Speech("Не получится, мы не на той странице");
            }
            
                    
    state: endSession
        intent!: /endSession
        script:
            var routingState = $request.rawRequest.payload.meta.current_app.state.routingState
            $jsapi.log("endSession")
            if (routingState == "session") {
                reply( {
                        "pronounceText": "Хорошо, результаты голосования перед вами на экране",
                        items: [ 
                            formEndSessionCommand() 
                        ]
                    },
                    $response);
            } else {
                sendAnswer_Speech("Не получится, мы не на той странице");
            }

    state: help
        intent!: /help
        script:
            reply( {
                "pronounceText": "Хорошо, вот список доступных команд",
                items: [ 
                    formHelpCommand() 
                ]
            },
            $response);

            
            
          