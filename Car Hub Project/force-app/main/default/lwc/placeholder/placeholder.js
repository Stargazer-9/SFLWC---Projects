import { api, LightningElement } from 'lwc';

// import static resource reference
import CAR_HUB_PLACEHOLDER from '@salesforce/resourceUrl/placeholder';

export default class Placeholder extends LightningElement {

    // create public property message
    @api message;

    placeholderUrl = CAR_HUB_PLACEHOLDER;
}