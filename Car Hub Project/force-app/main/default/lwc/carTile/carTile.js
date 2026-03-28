import { LightningElement, api } from 'lwc';

export default class CarTile extends LightningElement {

    @api car={};    // initialize with empty object, to avoid null pointer exception/undefined or breakage when no data is present

    //on click this method will call and dispach event 'selected'
    handleClick(){
        this.dispatchEvent(new CustomEvent('selected', {    //eventname-selected
            detail: this.car.Id
        }))
    };
        
}