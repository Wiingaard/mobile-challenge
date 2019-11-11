import moment from 'moment'

export function dateFormatted(dateString: string): string {
    return moment(dateString).format("MMMM Do, YYYY")
}

export function timeFormatted(dateString: string): string {
    return moment(dateString).format("HH:mm")
}