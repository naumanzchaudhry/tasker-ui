import { defineStore } from 'pinia'
import axios from 'axios'

export const useTodoStore = defineStore('todo', {
  state: () => ({
    todos: []
  }),
  actions: {
    async fetchTodos() {
      const response = await axios.get('/todos')
      this.todos = response.data
    },
    async addTodo(text) {
      const response = await axios.post('/todos', { text })
      this.todos.push(response.data)
    },
    async toggleTodo(id, completed) {
      await axios.put(`/todos/${id}`, { completed })
      const todo = this.todos.find((todo) => todo.id === id)
      if (todo) {
        todo.completed = completed
      }
    },
    async deleteTodo(id) {
      await axios.delete(`/todos/${id}`)
      this.todos = this.todos.filter((todo) => todo.id !== id)
    }
  }
})
