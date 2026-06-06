import { Controller } from "@hotwired/stimulus"

// 中カテゴリの横スクロールタブを管理する
// - ページ表示時に選択中カテゴリを中央までスクロールする（クリック後に位置が戻らないようにする）
// - 左右の矢印ボタンでスクロールする
// - スクロールできる端に到達した矢印は非表示にする
export default class extends Controller {
  static targets = ["scroller", "leftArrow", "rightArrow"]

  connect() {
    this.scrollToActive()
    this.update()

    // ウィンドウサイズが変わったときも矢印の表示を更新する
    this.boundUpdate = this.update.bind(this)
    window.addEventListener("resize", this.boundUpdate)
  }

  disconnect() {
    window.removeEventListener("resize", this.boundUpdate)
  }

  // 選択中カテゴリが中央に来るようスクロールする
  scrollToActive() {
    const active = this.scrollerTarget.querySelector("[data-category-active='true']")
    if (!active) return

    const scroller = this.scrollerTarget
    const offset = active.offsetLeft - scroller.clientWidth / 2 + active.offsetWidth / 2
    scroller.scrollLeft = offset
  }

  // 左の矢印を押したとき：表示幅の約7割だけ左へスクロールする
  scrollToLeft() {
    this.scrollerTarget.scrollBy({ left: -this.scrollerTarget.clientWidth * 0.7, behavior: "smooth" })
  }

  // 右の矢印を押したとき：表示幅の約7割だけ右へスクロールする
  scrollToRight() {
    this.scrollerTarget.scrollBy({ left: this.scrollerTarget.clientWidth * 0.7, behavior: "smooth" })
  }

  // スクロール位置に応じて矢印の表示/非表示を切り替える
  update() {
    const el = this.scrollerTarget
    const atStart = el.scrollLeft <= 0
    const atEnd = el.scrollLeft + el.clientWidth >= el.scrollWidth - 1
    const noOverflow = el.scrollWidth <= el.clientWidth

    // 左端 or スクロール不要なら左矢印を隠す
    this.leftArrowTarget.classList.toggle("hidden", atStart || noOverflow)
    // 右端 or スクロール不要なら右矢印を隠す
    this.rightArrowTarget.classList.toggle("hidden", atEnd || noOverflow)
  }
}
