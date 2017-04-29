let eventsContainer = document.querySelector("#events")

let presenter = {
  handleEvent: function(payload) {
    if (payload.type == "example_result" && payload.status == "passed") {
      let eventElement = document.createElement("span");
      eventElement.innerText = '.';
      eventsContainer.appendChild(eventElement);
    }
    else {
      let eventElement = document.createElement("pre");
      eventElement.innerText = `${JSON.stringify(payload, null, 2)}`
      eventsContainer.appendChild(eventElement)
    }
  }
}

export default presenter
