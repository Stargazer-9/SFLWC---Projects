import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import CAR_OBJECT from '@salesforce/schema/Car__c';

// Car Schema
import CATEGORY_FIELD from '@salesforce/schema/Car__c.Category__c';
import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c';

// constants 
const CATEGORY_ERROR = 'Error loading categories';
const MAKE_ERROR = 'Error loading Make Types';

// adding Lightning Message Service and a message channel
import CARS_FILTERED_MESSAGE from '@salesforce/messageChannel/CarsFiltered__c'; // message channel name
import { publish, MessageContext } from 'lightning/messageService';

export default class CarFilter extends LightningElement {
    filters = {
        searchKey: '',
        maxPrice: 999999,
    };

    categoryError = CATEGORY_ERROR;
    makeError = MAKE_ERROR;
    
    // timer to delay publish
    timer;


    // Load context from LMS
    @wire(MessageContext)
    messageContext;


    // fetching Category picklist
    @wire(getObjectInfo, {objectApiName: CAR_OBJECT})
    carObjectInfo;              // property that stores the data

    @wire(getPicklistValues, {
        recordTypeId: '$carObjectInfo.data.defaultRecordTypeId',   // adapter configuration
        fieldApiName: CATEGORY_FIELD
    })categories;

    // fetching Make picklist
    @wire(getPicklistValues, {
        recordTypeId: '$carObjectInfo.data.defaultRecordTypeId',
        fieldApiName: MAKE_FIELD
    })makeType;

    // Search Key Change Handler
    handleSearchKeyChange(event) {
        console.log(event.target.value);        
        this.filters = { ...this.filters, "searchKey": event.target.value };

        this.sendDataToCarList();
    }

    // Price Range Handler
    handleMaxPriceChange(event) {
        console.log(event.target.value);        
        this.filters = { ...this.filters, "maxPrice": event.target.value };

        this.sendDataToCarList();
    }

    handleCheckbox(event){
        if (!this.filters.categories) { // run only 1st time
            const categories = this.categories.data.values.map(item => item.value);
            const makeType = this.makeType.data.values.map(item => item.value);
            this.filters = {...this.filters, categories, makeType}; // fetch all values & add to filters
        }
        const {name, value} = event.target.dataset; // name - category, makeType, value - value of the checkbox
        // const {checked} = event.target;
        console.log("name", name);
        console.log("value", value);
        
        if (event.target.checked) { // property checked tells whether check box if T/F i.e. checked/unchecked
            if (!this.filters[name].includes(value)) {
                // when checked/true
                this.filters[name] = [...this.filters[name], value];        
            } 
        } else {
            // when unchecked/false
            this.filters[name] = this.filters[name].filter(item => item !== value); // filter property returns new array
        }

        this.sendDataToCarList();
    }

    // to publish message
    sendDataToCarList(){
        // cancel previous timer & reinitialize it
        window.clearTimeout()
        // timer to dela publish to calling method at multiple steps
        this.timer = window.setTimeout( () => {
            
            publish(this.messageContext, CARS_FILTERED_MESSAGE, {
                filters: this.filters   // pass data from message channel field name property
            });
        }, 400);    // 400sec
    }
}