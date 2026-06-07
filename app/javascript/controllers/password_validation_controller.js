import { Controller } from "@hotwired/stimulus"

// パスワード変更フォームのバリデーション
// - 新しいパスワードと確認のどちらか一方だけが入力されている場合にエラー
// - 新しいパスワードと確認が一致しない場合にエラー
export default class extends Controller {
  static targets = ["password", "confirmation", "error"]

  validate(event) {
    const password     = this.passwordTarget.value
    const confirmation = this.confirmationTarget.value

    // 両方空欄ならパスワード変更なし→バリデーション不要
    if (password === "" && confirmation === "") {
      this.clearError()
      return
    }

    // 片方だけ入力されている場合
    if (password === "" || confirmation === "") {
      event.preventDefault()
      this.showError("新しいパスワードと新しいパスワード（確認）の両方を入力してください")
      return
    }

    // 両方入力されているが一致しない場合
    if (password !== confirmation) {
      event.preventDefault()
      this.showError("新しいパスワードと新しいパスワード（確認）が一致しません")
      return
    }

    this.clearError()
  }

  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("hidden")
    this.errorTarget.scrollIntoView({ behavior: "smooth", block: "nearest" })
  }

  clearError() {
    this.errorTarget.textContent = ""
    this.errorTarget.classList.add("hidden")
  }
}
