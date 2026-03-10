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
    # Ruby から notebook を実行する公開API
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
    # 後方互換: input: の旧名称 notebook: も引き続き使用可能
    #   result = RubyPyMill::API.run(
    #     notebook: "examples/notebooks/lang_radar.ipynb",
    #     ...
    #   )
    #
    def self.run(
      input: nil,
      notebook: nil,
      output:,
      kernel: "rpymill",
      cell_tags: nil,
      params: nil,
      log: nil,
      dry_run: false,
      logger: $stdout,
      cwd: nil
    )
      # notebook: は input: の旧名称（後方互換）
      # Add `notebook:` as a backward-compatible alias for `input:` in API.run
      resolved_input = input || notebook
      raise ArgumentError, "input: (or notebook:) is required" if resolved_input.nil?

      runner = Runner.new(
        kernel: kernel,
        cwd: cwd,
        logger: logger,
        cell_tags: cell_tags
      )

      result = runner.run(
        input_ipynb: resolved_input,
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