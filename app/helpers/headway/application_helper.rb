class Headway
  module ApplicationHelper

    def l(time, *args)
      time ? super(time, *args) : "/"
    end

    def highlight_explain_query(explain)
      explain = explain.gsub("Seq Scan", "<b class='color-alert'>Seq Scan</b>")
      explain = explain.gsub("Index Scan", "<b class='color-success'>Index Scan</b>")
      explain = explain.gsub("Index Only Scan", "<b class='color-success'>Index Only Scan</b>")
      explain.html_safe
    end

  end
end
