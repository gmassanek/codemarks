Rails.logger.instance_variable_get(:@logger).instance_variable_get(:@log_dest).sync = true if Rails.logger
