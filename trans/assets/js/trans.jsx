import _ from 'lodash';
import $ from 'jquery';
import React from 'react';
import ReactDOM from 'react-dom';

const message_limit = 25;

export default function chat_init(root, channel) {
  ReactDOM.render(<Trans channel={channel} />, root);
}

class Trans extends React.Component {
  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.state = {
      messages: [],
      players: [],
      lang: window.userLang,
    };
    let lang = this.state.lang
    this.channel.join(lang)
      .receive("ok", this.onJoin.bind(this))
      .receive("error", resp => { console.log(resp); });

    this.channel.on("new message", payload => {
      let message = payload.user + ": " + payload.message;
      let new_array = this.addMessage(message);
      let state1 = _.assign({}, this.state, { messages: new_array })
      this.setState(state1)
    })

    this.channel.on("update", payload => {
      if (payload.result) {
        alert(payload.result)
      }
      this.setState(payload.chat)
    })
  }

  onJoin({ chat }) {
    this.setState(chat);
  }

  onUpdate({ chat }) {
    this.setState(chat);
  }

  updateChat({ chat }) {
    // let state1 = _.assign({}, this.state, {messages: message})
    this.setState(chat)
  }


  addMessage(message) {
    var new_array = this.state.messages;
    if (new_array.length < message_limit) {
      new_array.push(message);
    }
    else {
      for (let i = 0; i < new_array.length - 1; i++) {
        new_array[i] = new_array[i + 1];
      }
      new_array[new_array.length - 1] = message
    }
    return new_array
  }


  //   clicked(key) {
  //       this.channel.push("click", {i: key[0], j: key[1]})
  //       .receive("ok", this.onUpdate.bind(this));
  //   }

  // https://www.youtube.com/watch?v=e5jlIejl9Fs
  sendChatMessage(event) {
    if (event.key === "Enter") {
      let message = event.target.value;
      // $.post("/api/v1.5/tr/detect?hint=en,de&key=trnsl.1.1.20191119T004410Z.6b5c7982726f875c.aa7cc791e290a25f4a172ac5928617bd582ca172",
      //   {
      //     Host: "translate.yandex.net",
      //     Accept: "*",
      //     text={ message },
      //   }, (resp) => console.log(resp));
      event.target.value = "";
      this.channel.push("chat", { message: message, lang: this.state.lang })
      // .receive("ok", this.updateChat.bind(this));
    }
  }

  render() {
    return (
      <div>
        <div id="chat_window">
          <Messages root={this} />
        </div>
        <Chat root={this} />
      </div >

    );

  }
}

function Messages(props) {
  let { root } = props;

  return (
    _.map(root.state.messages, (message, i) => {
      if (i == 3) {
        return (<div key={i}>
          <img className="image" src="/images/disneynature-penguins.jpg"></img>
        </div>);
      }
      return (<div key={i} className="message">{message}</div>);
    })
  );
}

function Chat(props) {
  let { root } = props;
  return (
    <div>
      <input id="chatInput"
        placeholder="Type Something" type="text" onKeyDown={(e) => root.sendChatMessage(e)}></input>
    </div>
  )
};


// This is needed to check if two arrays
// are equal because Javascript blows and can't do it by itself
function checkArrays(arrayA, arrayB) {
  for (let i = 0; i < arrayA.length; i++) {
    if (arrayA[i] != arrayB[i]) {
      return false
    }
  }
  return true
}
