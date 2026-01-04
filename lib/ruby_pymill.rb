# frozen_string_literal: true

require_relative "ruby_pymill/version"
require_relative "ruby_pymill/api"
require "json"
require "open3"
require "tmpdir"

module RubyPyMill
  class Runner
    def initialize(kernel: "rpymill", cwd: nil, logger: $stdout, cell_tags: [])
      @kernel    = kernel
      @cwd       = cwd
      @logger    = logger
      @cell_tags = normalize_tags(cell_tags)  # ← 文字列/配列どちらでもOKに
    end

    # params_json: path to json file or JSON string
    # cell_tags  : initialize の指定を上書き可能（カンマ/空白区切り文字列 or 配列）
    def run(input_ipynb:, output_ipynb:, params_json: nil, kernel: nil, dry_run: false, cell_tags: nil)
      k    = kernel || @kernel
      tags = normalize_tags(cell_tags.nil? ? @cell_tags : cell_tags)  # ← 正規化して複数タグ対応

      # 1) タグ指定があればノートを事前フィルタ
      filtered_input = tags.empty? ? input_ipynb : filter_by_tags(input_ipynb, tags)

      # 2) papermill コマンドを組み立て
      args = ["papermill", filtered_input, output_ipynb, "-k", k]

      if params_json
        if File.exist?(params_json)
          args += ["-f", params_json]
        else
          tmpdir = Dir.mktmpdir("rpymill_params")
          tmp    = File.join(tmpdir, "params.json")
          File.write(tmp, params_json)
          args += ["-f", tmp]
        end
      end

      cmd = args.join(" ")
      @logger.puts "[RubyPyMill] #{dry_run ? 'DRY' : 'RUN'}: #{cmd}"
      return true if dry_run

      stdout_str, stderr_str, status = Open3.capture3(cmd, chdir: @cwd || Dir.pwd)
      @logger.puts stdout_str unless stdout_str.empty?
      @logger.puts stderr_str unless stderr_str.empty?
      status.success?
    end

    private

    # "preprocess, analysis" / "preprocess analysis" / ["preprocess","analysis"] いずれもOKに
    def normalize_tags(value)
      Array(value)
        .flat_map { |v| v.to_s.split(/[,\s]+/) }
        .map(&:strip)
        .reject(&:empty?)
        .uniq
    end

    # 指定タグ OR マッチ。parameters / injected-parameters は常に残す
    def filter_by_tags(ipynb_path, tags)
      data  = JSON.parse(File.read(ipynb_path))
      cells = data["cells"] || []

      kept = cells.select do |cell|
        ctags = Array(cell.dig("metadata", "tags")).map(&:to_s)
        (ctags & %w[parameters injected-parameters]).any? || (ctags & tags).any?
      end

      # 万一ゼロ件なら parameters 系のみ確保
      if kept.empty?
        kept = cells.select { |c| (Array(c.dig("metadata", "tags")) & %w[parameters injected-parameters]).any? }
      end

      filtered = data.dup
      filtered["cells"] = kept

      tmpdir = Dir.mktmpdir("rpymill_nb")
      tmpnb  = File.join(tmpdir, File.basename(ipynb_path, ".ipynb") + ".filtered.ipynb")
      File.write(tmpnb, JSON.pretty_generate(filtered))
      tmpnb
    end
  end
end
