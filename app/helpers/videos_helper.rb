module VideosHelper
    # convert_tsv_timestamp
    #  args: t = "35600" the time in milliseconds
    #  returns: { seconds: 35.60, display: "0:35.60"}
    def convert_tsv_timestamp(t = "35600")
        time_seconds = t.to_i/1000.0
        return {seconds: 0, display: "0"} if time_seconds == 0
        frac = (time_seconds - time_seconds.to_i).round(2)
        if time_seconds >=60
            minutes = time_seconds.to_i/60
            seconds = time_seconds.to_i % 60
            display = "#{minutes}:#{seconds.to_s.rjust(2,'0')}.#{(frac * 100).to_i.to_s.rjust(2,'0')}"
        else
            display = "#{(((time_seconds.to_i % 60) + time_seconds - time_seconds.to_i).round(2)).to_s}"
        end
        {seconds: time_seconds, display: display}
    end
end
