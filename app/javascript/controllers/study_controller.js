import { Controller } from "@hotwired/stimulus"

// 単語帳テスト画面のカード操作を管理する
// - カードの表/裏切り替え
// - 覚えた/覚えていないの記録保存
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

  // 「覚えた」「覚えていない」ボタン押下時に記録を保存して次へ進む
  async remember(event) {
    const remembered = event.currentTarget.dataset.remembered
    const wordId = this.cardTargets[this.currentIndex].dataset.wordId

    await fetch("/learning_records", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ word_id: wordId, remembered: remembered })
    })

    this.next()
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
