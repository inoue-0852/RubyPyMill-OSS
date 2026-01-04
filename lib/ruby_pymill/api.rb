# lib/ruby_pymill/api.rb
require "open3"

module RubyPyMill
  module API
    # Ruby から notebook を実行する公式API
    #
    # 例:
    #   RubyPyMill::API.run(
    #     notebook: "demo/notebooks/xxx.ipynb",
    #     output:   "demo/outputs/out.ipynb",
    #     kernel:   "rpymill",
    #     cell_tags:"setup,preprocess,report",
    #     params:   "demo/params/kodama.json",
    #     log:      "demo/logs/run_xxx.log"
    #   )
    #
    def self.run(
      notebook:,
      output:,
      kernel: "rpymill",
      cell_tags: nil,
      params: nil,
      log: nil
    )
      cmd = [
        "ruby_pymill", "exec",
        notebook,
        "--output", output,
        "--kernel", kernel,
      ]
      cmd += ["--cell-tag", cell_tags] if cell_tags && !cell_tags.empty?
      cmd += ["--params", params]      if params && !params.empty?

      stdout_all = +""
      status = nil

      Open3.popen2e(*cmd) do |_stdin, stdout_err, wait_thr|
        stdout_err.each do |line|
          print line          # コンソールにも流す
          stdout_all << line  # ログにも残す
        end
        status = wait_thr.value
      end

      if log
        log_dir = File.dirname(log)
        Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
        File.write(log, stdout_all)
      end

      unless status&.success?
        raise "ruby_pymill failed (status=#{status.exitstatus})"
      end

      stdout_all
    end
  end
end
