class TemplateAssetPreprocessor < Sprockets::Processor
  def evaluate(context, locals)
    p context
    RAILS.logger.info context.inspect
  end
end
