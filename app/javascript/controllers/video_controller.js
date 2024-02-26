import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"] // assuming you want to update an element with the "output" target
  static values = { title: String, videoid: Number, tag: String }

  connect() {
    console.log("Hello from javascript/controllers/video_controller.js#connect");
  }

  test() {
    alert('test');
  }
  
  addTag() {
    fetch("/videos/" + this.videoidValue + "/add_tag.json?tag=" + this.tagValue, {
        headers: { 
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "text/html"
        }
      }) // replace "/your_endpoint" with the path to your Rails action
      .then(response => response.text())
      .then(html => {
        const target = document.getElementById("video_" + this.videoidValue + "_tags");
        target.innerHTML = html;
      })
      .catch(error => console.log(error));
  }  

  removeTag() {
    fetch("/videos/" + this.videoidValue + "/remove_tag.json?tag=" + this.tagValue, {
        headers: { 
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "text/html"
        }
      }) // replace "/your_endpoint" with the path to your Rails action
      .then(response => response.text())
      .then(html => {
        const target = document.getElementById("video_" + this.videoidValue + "_tags");
        target.innerHTML = html;
      })
      .catch(error => console.log(error));
  }  

  setTitle() {
    // alert("setTitle: " + this.titleValue + " for video " + this.videoidValue);
    fetch("/videos/" + this.videoidValue + "/set_title?title=" + this.titleValue) // replace "/your_endpoint" with the path to your Rails action
      .then(response => response.json())
      .then(data => {
        console.log("Returned from setTitle");
        console.log(data);
        const target = document.getElementById("video_" + this.videoidValue + "_title");
        target.innerHTML = data.title;
      })
      .catch(error => console.log(error));
  }
}
