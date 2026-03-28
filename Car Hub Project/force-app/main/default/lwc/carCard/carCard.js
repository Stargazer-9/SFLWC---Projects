import { LightningElement, wire } from 'lwc';

//Car__c Schema - import all required fields

import NAME_FIELD from '@salesforce/schema/Car__c.Name'
import PICTURE_URL_FIELD from '@salesforce/schema/Car__c.Picture_URL__c'
import CATEGORY_FIELD from '@salesforce/schema/Car__c.Category__c'
import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c'
import MSRP_FIELD from '@salesforce/schema/Car__c.MSRP__c'
import FUEL_FIELD from '@salesforce/schema/Car__c.Fuel_Type__c'
import SEATS_FIELD from '@salesforce/schema/Car__c.Number_of_Seats__c'
import CONTROL_FIELD from '@salesforce/schema/Car__c.Control__c'

import CAR_OBJECT from '@salesforce/schema/Car__c'

// getFieldValue function is used to extract field values
import {getFieldValue} from 'lightning/uiRecordApi'

// Lightning Message Service and a message channel
import CARS_SELECTED_MESSAGE from '@salesforce/messageChannel/CarSelected__c';
import { subscribe, MessageContext, unsubscribe } from 'lightning/messageService';


// Navigation import
import {NavigationMixin} from 'lightning/navigation'


export default class CarCard extends NavigationMixin(LightningElement) {

    // load context for LMS
    @wire(MessageContext)
    messageContext

    //exposing fields to make them available in the template
    //to map the imported fields to the properties as they cant be directly used in the template/HTML
    nameField = NAME_FIELD
    pictureUrlField = PICTURE_URL_FIELD
    categoryField = CATEGORY_FIELD
    makeField = MAKE_FIELD 
    msrpField = MSRP_FIELD
    fuelField = FUEL_FIELD
    seatsField = SEATS_FIELD
    controlField = CONTROL_FIELD

    //Id of Car__c to display data
    // recordId = 'a00Qy00001adeTNIAY'
    recordId;   //made dynamic

    // car fields displayed with specific format
    carName
    carPictureUrl
    handleRecordLoaded(event){
        const {records} = event.detail
        const recordData = records[this.recordId]
        this.carName = getFieldValue(recordData, NAME_FIELD)
        this.carPictureUrl = getFieldValue(recordData, PICTURE_URL_FIELD)
    }

    connectedCallback(){
        // subscribe to message channel
        this.subscribeHandler();
    }
    
    subscribeHandler(){
        this.carSelectionSubscription = subscribe(this.messageContext, CARS_SELECTED_MESSAGE, (message) => this.handleCarSelected(message));
    }

    // subscription reference for carSelected
    carSelectionSubscription; 

    handleCarSelected(message){
        // console.log(carId);      //to debug issues      
        this.recordId = message.carId;  // message is an object with carId property
    }

    disconnectedCallback(){
        unsubscribe(this.carSelectionSubscription);
        this.carSelectionSubscription = null;
    }

    // navigate to record page
    handleNavigateToRecord(){
        // first import navigation mixin and wrap/extend it in the component
        this[NavigationMixin.Navigate]({    // caling method navigate
            type:'standard_recordPage',     //passing parameters
            attributes:{
                recordId:this.recordId,
                objectApiName:CAR_OBJECT.objectApiName, // import object from car schema
                actionName:'view'
            }
        })
    }
}