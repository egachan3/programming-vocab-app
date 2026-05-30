import { Controller } from "@hotwired/stimulus"

// 単語帳テスト画面のカード操作を管理する
// - カードの表/裏切り替え
// - 次の単語への遷移
// - 全問終了時に完了画面を表示
export default class extends Controller {
  static targets = ["card", "completion", "current", "total"]

  connect() {
    this.currentIndex = 0
    this.updateProgress()
  }

  // カードをクリックすると表/裏を切り替える
  flip(event) {
    const card = event.currentTarget.closest("[data-study-target='card']")
    card.classList.toggle("is-flipped")
  }

  // 次の単語に進む
  next() {
    const activeCard = this.cardTargets[this.currentIndex]
    activeCard.classList.remove("is-active")

    this.currentIndex += 1

    if (this.currentIndex >= this.cardTargets.length) {
      this.completionTarget.classList.add("is-visible")
    } else {
      this.cardTargets[this.currentIndex].classList.add("is-active")
      this.updateProgress()
    }
  }

  updateProgress() {
    this.currentTarget.textContent = this.currentIndex + 1
    this.totalTarget.textContent = this.cardTargets.length
  }
}
