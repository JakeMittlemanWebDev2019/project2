// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import $ from "jquery";

import socket from "./socket";
import chat_init from "./trans.jsx";

$(() => {
    let root = $('#root')[0];
    if (root) {
        let channel = socket.channel("chats:" + window.chatName, {});
        chat_init(root, channel);
    }
});