function reply(body, response) {
    var replyData = {
        type: "raw",
        body: body
    };
    response.replies = response.replies || [];
    response.replies.push(replyData);
}

function sendAnswer_Speech(text) {
    var response = $jsapi.context().response;
    var reply = {
        type: "raw",
        body: {
            "pronounceText": text
        }
    };
    response.replies = response.replies || [];
    response.replies.push(reply);
}

function replyWithButtons(response, myButtons) {
    var replyData = {
        type: "buttons",
        buttons: myButtons
    };
    response.replies = response.replies || [];
    response.replies.push(replyData);
}

function formAddFilmCommand(filmToAdd) {
    return {
        "command": {
            type: "smart_app_data",
            smart_app_data: {
                command: "add_film",
                film: filmToAdd
            }
        }
    }
}

function formOpenSessionCommand() {
    return {
        "command": {
            type: "smart_app_data",
            smart_app_data: {
                command: "open_session"
            }
        }
    }
}

function formEndSessionCommand() {
    return {
        "command": {
            type: "smart_app_data",
            smart_app_data: {
                command: "end_session"
            }
        }
    }
}

function formHelpCommand() {
    return {
        "command": {
            type: "smart_app_data",
            smart_app_data: {
                command: "help"
            }
        }
    }
}

function formReturnCreateCommand()  {
    return {
        "command": {
            type: "smart_app_data",
            smart_app_data: {
                command: "return_create"
            }
        }
    }
}
