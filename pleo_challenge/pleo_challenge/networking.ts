
const BASE_URL = "http://localhost:3000"

export interface Expense {
    id: string;
    amount: {
        value: string,
        currency: string
    };
    date: string;
    merchant: string;
    receipts: any[];
    comment: string;
    category: string;
    user: {
        first: string,
        last: string,
        email: string
    };
}

export interface ExpenseRequestParameters { 
    offset: number, 
    limit: number 
}

export function getExpenses(params: ExpenseRequestParameters): Promise<Expense[]> {
    const request: RequestInit = {
        method: 'GET'
    }

    const query = BASE_URL + `/expenses?limit=${params.limit}&offset=${params.offset}`

    return fetch(query, request)
        .then(response => { return response.json() })
        .then(json => {
            return json.expenses as Expense[]
        })
        .catch(error => {
            console.error(`'GET /expenses': ${error}`)
            return Promise.reject(error)
        })
}
