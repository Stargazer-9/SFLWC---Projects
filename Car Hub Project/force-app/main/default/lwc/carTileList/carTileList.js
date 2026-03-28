import getCars from '@salesforce/apex/CarController.getCars';
import { LightningElement, wire } from 'lwc';

// Lightning Message Service and a message channel
import CARS_FILTERED_MESSAGE from '@salesforce/messageChannel/CarsFiltered__c';
import CARS_SELECTED_MESSAGE from '@salesforce/messageChannel/CarSelected__c';
import { subscribe, MessageContext, publish, unsubscribe } from 'lightning/messageService';

export default class CarTileList extends LightningElement {

    //create property to store data fetched from apex
    cars = [];
    error;
    // create property filters and initialize it with empty object
    filters = {};

    carFilterSubscription;  // store subscription to unsubscribe later if needed

    // @wire(getCars)
    // create wire method to call apex method, by passing config same param, and making it reactive with '$'
    @wire(getCars, {filters:'$filters'})
    carsHandler({data, error}) {
        if(data) {
            console.log(data);
            this.cars = data;
        }
        if(error) {            
            console.error(error);
            this.error = error;
        }
    }

    // Load context to LMS
    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        // subscribe to message channel
        this.subscribeHandler();
    }

    subscribeHandler(){
        // instance of subscribe gets stored 
        this.carFilterSubscription = subscribe(this.messageContext, CARS_FILTERED_MESSAGE, (message) => this.handleFilterChanges(message));
    }

    handleFilterChanges(message){
        console.log(message.filters);   
        // filters detect change and recall the getCars method 
        this.filters = {...message.filters};    // spread & assign ; generates new copy not imitate the data directly

    }

    handleCarSelected(event){
        console.log("selected car id:", event.detail);
        //publish the event once received
        publish(this.messageContext, CARS_SELECTED_MESSAGE, {
            carId: event.detail
        });
    }

    disconnectedCallback(){
        unsubscribe(this.carFilterSubscription);
        this.carFilterSubscription = null;
    }
}
