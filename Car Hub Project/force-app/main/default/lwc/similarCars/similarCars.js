import { api, LightningElement, wire } from 'lwc';
import getSimilarCars from '@salesforce/apex/CarController.getSimilarCars'
import { getRecord } from 'lightning/uiRecordApi';

import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c'

import {NavigationMixin} from 'lightning/navigation'


export default class SimilarCars extends NavigationMixin(LightningElement) {

    //directly get the id since we are inside the record page using api
    @api recordId

    @wire(getRecord, {recordId: '$recordId', fields:[MAKE_FIELD]})
    car             // store the data as property in car

    similarCars;


    fetchSimilarCars(){
        // apex call
        getSimilarCars({
            carId:this.recordId,
            makeType: this.car.data.fields.Make__c.value    // fetch make type using getrecord adaptor
        }).then(result => {
            this.similarCars = result;
            console.log(this.similarCars);
        }).catch(error => {
            console.error(error)
        });
        console.log(this.car.data);
         
    }

    @api objectApiName

    handleViewDetailsClick(event){
        this[NavigationMixin.Navigate]({
            type:'standard_recordPage',
            attributes:{
                recordId: event.target.dataset.id,
                objectApiName: this.objectApiName,
                actionName: 'view'
            }
        })
    }
}