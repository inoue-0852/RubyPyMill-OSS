# lib/ruby_pymill/api.rb
require "fileutils"

module RubyPyMill
  class Error < StandardError; end
  class ExecutionError < Error; end

  Result = Struct.new(
    :success,
    :output,
    :filtered_input,
    :command,
    :stdout,
    :stderr,
    keyword_init: true
  ) do
    def success?
      success
    end
  end

  module API
    # Ruby から notebook を実行する公開API（experimental）
    #
    # 例:
    #   result = RubyPyMill::API.run(
    #     input:     "examples/notebooks/lang_radar.ipynb",
    #     output:    "examples/outputs/lang_radar_out.ipynb",
    #     kernel:    "rpymill",
    #     cell_tags: "parameters,setup,graph_output",
    #     params:    "examples/params/lang_radar.json",
    #     log:       "examples/logs/lang_radar.log"
    #   )
    #
    #   puts result.output
    #
    def self.run(
      input:,
      output:,
      kernel: "rpymill",
      cell_tags: nil,
      params: nil,
      log: nil,
      dry_run: false,
      logger: $stdout,
      cwd: nil
    )
      runner = Runner.new(
        kernel: kernel,
        cwd: cwd,
        logger: logger,
        cell_tags: cell_tags
      )

      result = runner.run(
        input_ipynb: input,
        output_ipynb: output,
        params_json: params,
        kernel: kernel,
        dry_run: dry_run,
        cell_tags: cell_tags
      )

      if log
        log_dir = File.dirname(log)
        FileUtils.mkdir_p(log_dir)
        File.write(log, [result.stdout, result.stderr].reject(&:empty?).join)
      end

      unless result.success?
        raise ExecutionError, "ruby_pymill failed"
      end

      result
    end
  end
end