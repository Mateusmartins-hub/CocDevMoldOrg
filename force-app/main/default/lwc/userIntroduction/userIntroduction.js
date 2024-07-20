import { api, LightningElement, track, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import Id from "@salesforce/user/Id";
import getUser from "@salesforce/apex/UserIntroductionController.getUser";
import updateUser from "@salesforce/apex/UserIntroductionController.updateUser";

import USER_INTRODUCTION from "@salesforce/resourceUrl/UserIntroductionJsonForCommunities";

export default class UserIntroduction extends LightningElement {
  @api community;

  @track userList;
  @track userToRefresh;
  @track showList = false;

  userId = Id;
  userRecord;

  @wire(getUser, { userId: "$userId" })
  user(value) {
    this.userToRefresh = value;

    const { error, data } = value;

    if (data) {
      // console.log("User Query Data:", data);
      this.userRecord = JSON.stringify(data);
      this.showIntroduction();
    } else if (error) {
      // console.log("User Query ERROR:", error);
    } else {
      // console.log("User Query UNKNOWN");
    }
  }

  connectedCallback() {
    let request = new XMLHttpRequest();
    request.open("GET", USER_INTRODUCTION, false);
    request.send(null);

    this.userList = this.getJsonList(request.responseText);

    if (this.community == "Selecione uma marca") {
      this.userList = null;
      this.showList = false;
    }
  }

  renderedCallback() {
    // console.log("renderedCallback", this.userRecord);
    refreshApex(this.userToRefresh);
    // console.log("renderedCallback", this.userRecord);
  }

  showIntroduction() {
    // console.log("showIntroduction", this.userRecord);

    let user = JSON.parse(this.userRecord);

    this.showList = user.IntroductionToCommunity__c
      ? (typeof this.userList == "object" && this.userList != null) ||
        this.userList != ""
      : false;
  }

  closeIntroduction(e) {
    this.showList = false;
  }

  checkedIntroduction(e) {
    // console.log("e.target", e.target.checked);
    // console.log("userRecord", this.userRecord);

    let user = JSON.parse(this.userRecord);
    user.IntroductionToCommunity__c = !e.target.checked;

    // console.log("User", user);

    updateUser({ user: user })
      .then((result) => {
        // console.log(result);
      })
      .catch((error) => {
        console.log(error);
      });
  }

  getJsonList(j) {
    let listJSON = JSON.parse(j);
    let brandList;

    listJSON.forEach((e) => {
      if (e.communityName == this.community) {
        brandList = e.userIntroduction;
      }
    });

    return brandList;
  }
}