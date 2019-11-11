import { Expense, getExpenses, getExpense, postExpenseComment } from "./networking"

export class ExpenseManager {

    private page = 0
    private isLoading = false
    private expenses: Expense[] = []

    private parametersForPage(page: number, pageSize: number = 10): { offset: number, limit: number } {
        return {
            offset: page * pageSize,
            limit: pageSize
        }
    }

    private getExpensesForPage(page: number): Promise<Expense[]> {
        this.isLoading = true
        return getExpenses(this.parametersForPage(page))
            .then(expenses => {
                this.isLoading = false
                this.expenses = [...this.expenses, ...expenses]
                this.didUpdateExpenses(this.expenses)
                return expenses
            })
    }

    public getInitialExpenses(): Promise<Expense[]> {
        return this.getExpensesForPage(0)
    }

    public isScrolledCloseToBottom(isClose: boolean) {
        if (isClose && !this.isLoading) {
            this.page += 1
            this.getExpensesForPage(this.page)
        }
    }

    didUpdateExpenses(expenses: Expense[]) { }

    public getExpenseFor(expenseId: string): Promise<Expense> {
        return getExpense(expenseId)
    }

    public addCommentToExpense(expenseId: string, comment: string): Promise<Expense> {
        return postExpenseComment(expenseId, comment)
            .then(updatedExpense => {
                this.expenses = this.expenses.map(expense => { 
                    return expense.id === expenseId ? updatedExpense : expense 
                })
                this.didUpdateExpense(updatedExpense)
                return updatedExpense
            })
    }

    didUpdateExpense(expense: Expense) { }

}
