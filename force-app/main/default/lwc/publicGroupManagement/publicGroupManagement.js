import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import searchUsers from "@salesforce/apex/PublicGroupManagementController.searchUsers";
import searchGroups from "@salesforce/apex/PublicGroupManagementController.searchGroups";
import addGroupsToUsers from "@salesforce/apex/PublicGroupManagementController.addGroupsToUsers";
import removeUsersFromGroups from "@salesforce/apex/PublicGroupManagementController.removeUsersFromGroups";
import retrieveGroupsOfUser from "@salesforce/apex/PublicGroupManagementController.retrieveGroupsOfUser";
import checkPermission from "@salesforce/apex/PublicGroupManagementController.checkPermission";

const userColumns = [
    { label: 'Nome', fieldName: 'name' },
    { label: 'Alias', fieldName: 'alias' },
    { label: 'E-mail', fieldName: 'email' },
];

const groupColumns = [
    { label: 'Nome', fieldName: 'name' },
];

export default class PublicGroupManagement extends LightningElement {

    userColumns = userColumns;
    groupColumns = groupColumns;

    userHasPermission = false;
    groups = [];
    users = [];
    isLoading = false;
    step = 1;
    @track selectedUsers = [];
    @track selectedGroups = [];
    @track usersToGroups = [];

    connectedCallback() {
        this.checkPermission();
    }

    get currentStep() {
        return this.step;
    }

    set currentStep(value) {
        this.step = value;
        
        var allSteps = this.template.querySelectorAll('.step');
        allSteps.forEach(step => {
            step.style.display = "none";
        });

        var elem = this.template.querySelector(`[data-step="${value}"]`);
        elem.style.display = "block";

        if(value === 2){
            this.checkSelectedUser();
        }
        else if (value === 3) {
            this.checkSelectedUser();
            this.buildUsersToGroupData();
        }
    };

    get availableActions(){
        return [
            { label: 'Adicionar', value: 'add' },
            { label: 'Manter', value: 'keep' },
            { label: 'Remover', value: 'remove' },
        ];
    };

    get steps(){
        return [
        { label: 'Selecionar usuários', value: 1 },
        { label: 'Selecionar grupos', value: 2 },
        { label: 'Configurar', value: 3 }
    ]};

    get showBackButton() {
        return this.step > 1 ? true : false;
    }

    get showNextButton() {
        return this.step < 3;
    }

    get associateButtonDisabled(){
        return !this.usersToGroups.length ? true : false;
    }

    async checkPermission(){

        try {
            this.isLoading = true;
            this.userHasPermission = await checkPermission();
        } catch (error) {
            this.showErrorToast(error);
        } finally {
            this.isLoading = false;
        }
    }

    handleStepChange(e) {
        const { index } = e.detail;
        this.currentStep = index + 1;
    }

    handleChangeAction(e) {

        const { userid, groupid } = e.target.dataset;

        var item = this.template.querySelector(`[data-id="${groupid}"]`);
        
        switch (e.detail.value){
            case 'add':
                item.className ='tile__item add';
                break;
            case 'keep': 
                item.className ='tile__item keep';
                break;
            case 'remove': 
                item.className ='tile__item remove';
                break;
        }

        const user = this.usersToGroups.find(u => {
            return u.userId === userid
        });
        

        const group = user.groups.find(g => {
            return g.groupId == groupid
        });

        group.action = e.detail.value;

    }

    handleSelectUser(e) {
        const { selectedRows } = e.detail;
        this.selectedUsers = [...selectedRows];
    }
    
    handleSelectGroup(e) {
        const { selectedRows } = e.detail;
        this.selectedGroups = [...selectedRows];
    }

    handleSearchUser(e) {

        if(e.target.value.length < 2) return;

        this.searchUsers(e.target.value);
    }
    
    searchUsers = this.debounce(async (value) => {
        try {
            this.isLoading = true;
            
            this.users = [...this.selectedUsers];
            
            const result = await searchUsers({ searchTerm: value });

            if(!result) return;

            const usersIds = this.users.map(a => a.id);
            
            const uniqueResults = result.filter(r => {
                return !usersIds.includes(r.id)
            });
            
            this.users = this.users.concat(uniqueResults);

        } catch (error) {
            console.log(JSON.stringify(error));
            this.showErrorToast(error);
        } finally {
            this.isLoading = false;
        }
        
    }, 600);

    handleSearchGroup(e) {

        if(e.target.value.length < 2) return;

        this.searchGroups(e.target.value);
    }

    searchGroups = this.debounce(async (value) => {
        try {
            this.isLoading = true;
            
            this.groups = [...this.selectedGroups];
            
            const result = await searchGroups({ searchTerm: value });

            if(!result) return;

            const groupIds = this.groups.map(a => a.id);
            
            const uniqueResults = result.filter(r => {
                return !groupIds.includes(r.id)
            });
            
            this.groups = this.groups.concat(uniqueResults);

        } catch (error) {
            console.log(JSON.stringify(error));
            this.showErrorToast(error);
        } finally {
            this.isLoading = false;
        }
        
    }, 600);

    buildUsersToGroupData() {
        try{
            this.loading = true;

            this.usersToGroups = [];

            this.selectedUsers.forEach(userInput => {

                let user = this.usersToGroups.find(u => { return u.userId === userInput.id});

                if(!user) {
                    
                    user = {
                        userId: userInput.id,
                        userName: userInput.name,
                        userEmail: userInput.email,
                        userAlias: userInput.alias,
                        groups: []
                    };
                }
                
                this.selectedGroups.forEach(group => {

                    if(!user.groups){
                        user.groups = [];
                    }

                    if(user.groups.length){

                        const existingGroup = user.groups.find(g => { 
                            return g.groupId === group.id 
                        });

                        if(existingGroup) {
                            return;
                        }
                    }
                    
                    user.groups.push({
                        elemId: group.id + user.userId,
                        groupId: group.id,
                        groupName: group.name,
                        action: 'add',
                        actionClass: 'tile__item add'
                    });
                });

                this.usersToGroups.push(user);
            });
        } catch (error) {
            console.log(JSON.stringify(error));
            this.showErrorToast(error);
            this.loading = false;
        } finally {
            this.getGroupsOfSelectedUsers();
        }
    }

    async getGroupsOfSelectedUsers() {
        try {

            const result = await retrieveGroupsOfUser({ usersId: this.users.map(a => a.id) });

            if(!result) return;

            this.usersToGroups.forEach(user => {

                const userGroups = result[user.userId];

                if(!userGroups) return;
                
                userGroups.forEach(group => {

                    if(user.groups.length){
    
                        const existingGroup = user.groups.find(g => { 
                            return g.groupId === group.id 
                        });
    
                        if(existingGroup) {
                            return;
                        }
                    }
                    
                    user.groups.push({
                        elemId: group.id + user.userId,
                        groupId: group.id,
                        groupName: group.name,
                        action: 'keep',
                        actionClass: 'tile__item keep',
                        membershipId: group.membershipId
                    });
                });
            })
        } catch (error) {
            console.log(JSON.stringify(error));
            this.showErrorToast(error);
        } finally {
            this.loading = false;
        }
    }

    async associateUsers() {
        try {
            this.isLoading = true;

            const addGroupToUser = []
            const membershipsToRemove = [];

            this.usersToGroups.forEach(user => {
                const { groups } = user;

                groups.forEach(group => {
                    if(group.action === 'add'){
                        addGroupToUser.push({
                            user: user.userId,
                            group: group.groupId
                        });
                    }
                    else if(group.action === 'remove' && group.membershipId){
                        membershipsToRemove.push(
                            group.membershipId
                        )
                    }
                })
            });
            
            if(addGroupToUser) await addGroupsToUsers({ userToGroupJson: JSON.stringify(addGroupToUser) });

            if(membershipsToRemove) await removeUsersFromGroups({ membershipsIds: membershipsToRemove });

            this.showToast(
                'Sucesso!',
                'Os usuários foram associados aos grupos selecionados com sucesso!',
                'success'
            );

            this.reset();

        } catch (error) {
            console.log(JSON.stringify(error));
            this.showErrorToast(error);
        } finally {
            this.isLoading = false;
        }
    }

    nextStep() {
        this.currentStep = this.step + 1;
    }

    previousStep() {
        this.currentStep = this.step - 1;
    }

    showErrorToast(message) {
        this.showToast(
            'Erro!',
            message || 'Algum erro inesperado aconteceu!',
            'error'
        );
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }

    checkSelectedUser(){
        if(!this.selectedUsers.length){
            this.showErrorToast('É necessário selecionar pelo menos 1 usuário');
            this.currentStep = 1;
        }
    }

    reset(){
        this.users = [];
        this.selectedUsers = []
        this.groups = [];
        this.selectedGroups = []
        this.currentStep = 1;

        var inputElem = this.template.querySelector(`[name="user-search"]`);
        console.log(inputElem);
        
    }

    debounce(func, wait, immediate) {
        var timeout;
        return function() {
            var context = this, args = arguments;
            var later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    };
}