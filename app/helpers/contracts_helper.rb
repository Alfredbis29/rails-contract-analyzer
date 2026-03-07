module ContractsHelper

  # Status badge with dot indicator and full Tailwind styling
  STATUS_STYLES = {
    "draft"    => { bg: "bg-blue-50 text-blue-700 ring-blue-600/20",    dot: "bg-blue-500" },
    "active"   => { bg: "bg-green-50 text-green-700 ring-green-600/20",  dot: "bg-green-500" },
    "archived" => { bg: "bg-yellow-50 text-yellow-700 ring-yellow-600/20", dot: "bg-yellow-500" },
    "expired"  => { bg: "bg-red-50 text-red-700 ring-red-600/20",       dot: "bg-red-400" },
    "pending"  => { bg: "bg-orange-50 text-orange-700 ring-orange-600/20", dot: "bg-orange-400" },
  }.freeze

  def status_badge(status)
    key = status.to_s.downcase
    styles = STATUS_STYLES.fetch(key, { bg: "bg-gray-50 text-gray-600 ring-gray-500/20", dot: "bg-gray-400" })

    content_tag(:span, class: "inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold ring-1 ring-inset #{styles[:bg]}") do
      concat content_tag(:span, "", class: "w-1.5 h-1.5 rounded-full #{styles[:dot]}")
      concat status.titleize
    end
  end

  # Risk flag with severity levels: :low, :medium, :high
  RISK_STYLES = {
    low:    "bg-yellow-50 text-yellow-800 border border-yellow-300",
    medium: "bg-orange-50 text-orange-800 border border-orange-300",
    high:   "bg-red-50 text-red-800 border border-red-300 font-semibold",
  }.freeze

  def highlight_risk(flag, severity: :medium)
    css = RISK_STYLES.fetch(severity, RISK_STYLES[:medium])
    content_tag(:span, flag, class: "inline-block text-xs px-2 py-0.5 rounded #{css}")
  end

  # Human-readable relative date with a tooltip showing the full date
  def contract_date(datetime)
    return "—" if datetime.nil?
    content_tag(:span, time_ago_in_words(datetime) + " ago",
      title: datetime.strftime("%B %d, %Y at %H:%M"),
      class: "text-stone-400 text-xs cursor-help border-b border-dotted border-stone-300"
    )
  end

end