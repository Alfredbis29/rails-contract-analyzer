module ContractsHelper

  # Status badge with dot indicator and full Tailwind styling
  STATUS_STYLES = {
    "draft"    => { bg: "bg-blue-50 text-blue-700 ring-blue-600/20",      dot: "bg-blue-500" },
    "active"   => { bg: "bg-green-50 text-green-700 ring-green-600/20",   dot: "bg-green-500" },
    "archived" => { bg: "bg-yellow-50 text-yellow-700 ring-yellow-600/20", dot: "bg-yellow-500" },
    "expired"  => { bg: "bg-red-50 text-red-700 ring-red-600/20",         dot: "bg-red-400" },
    "pending"  => { bg: "bg-orange-50 text-orange-700 ring-orange-600/20", dot: "bg-orange-400" },
  }.freeze

  DEFAULT_STATUS_STYLE = { bg: "bg-gray-50 text-gray-600 ring-gray-500/20", dot: "bg-gray-400" }.freeze

  def status_badge(status)
    # FIX 1: use `key` (safe string) instead of raw `status` for titleize
    key    = status.to_s.downcase
    styles = STATUS_STYLES.fetch(key, DEFAULT_STATUS_STYLE)

    content_tag(:span, class: "inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold ring-1 ring-inset #{styles[:bg]}") do
      concat content_tag(:span, "", class: "w-1.5 h-1.5 rounded-full #{styles[:dot]}")
      concat key.titleize   # was: status.titleize  — crashes if status is nil
    end
  end

  # Risk flag with severity levels: :low, :medium, :high
  RISK_STYLES = {
    low:    "bg-yellow-50 text-yellow-800 border border-yellow-300",
    medium: "bg-orange-50 text-orange-800 border border-orange-300",
    high:   "bg-red-50 text-red-800 border border-red-300 font-semibold",
  }.freeze

  def highlight_risk(flag, severity: :medium)
    # FIX 4: coerce string → symbol so "high" and :high both work
    severity = severity.to_sym
    css = RISK_STYLES.fetch(severity, RISK_STYLES[:medium])
    content_tag(:span, flag, class: "inline-block text-xs px-2 py-0.5 rounded #{css}")
  end

  # Human-readable relative date with a tooltip showing the full date
  def contract_date(datetime)
    return "—" if datetime.nil?

    # FIX 3: guard against objects that don't respond to strftime (e.g. plain String)
    unless datetime.respond_to?(:strftime)
      raise ArgumentError, "contract_date expects a Time/Date object, got #{datetime.class}"
    end

    # FIX 2: time_ago_in_words + " ago" is wrong for future datetimes.
    # Branch so future dates read naturally instead of "3 days from now ago".
    relative =
      if datetime.past?
        "#{time_ago_in_words(datetime)} ago"
      else
        "in #{time_ago_in_words(datetime)}"
      end

    content_tag(
      :span,
      relative,
      title: datetime.strftime("%B %d, %Y at %H:%M"),
      class: "text-stone-400 text-xs cursor-help border-b border-dotted border-stone-300"
    )
  end

end