function DebugMonitorNetworkHandler() constructor
{
	// PING
	ping_samples = [];
	ping_samples_max_count = 600;
	ping_samples_max_value = 1;
	ping_sample_interval = 1000; //ms
	
	// OVER TIME PACKET LOSS COUNT
	packet_loss_samples = [];
	packet_loss_samples_max_value = 1;
	
	// DATA RATE
	data_rate_sample_interval = 1000; //ms
	data_rate_samples_max_count = 600;
	// DATA IN RATE
	data_in_samples = [];
	data_in_samples_max_value = 1;
	
	// DATA OUT RATE
	data_out_samples = [];
	data_out_samples_max_value = 1;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
		return;
	}
	
	static SamplePing = function(_ping)
	{
		if (array_length(ping_samples) >= ping_samples_max_count) array_shift(ping_samples);
		array_push(
			ping_samples,
			new DebugMonitorSample(current_time, max(0, _ping))
		);
		ping_samples_max_value = max(_ping, ping_samples_max_value);
	}
	
	static SampleDataRates = function(_lastDataOutRate, _lastDataInRate)
	{
		// DATA OUT RATE
		if (array_length(data_out_samples) >= data_rate_samples_max_count) array_shift(data_out_samples);
		var dataOutSampleKilobits = max(0, BytesToKilobits(_lastDataOutRate));
		array_push(
			data_out_samples,
			new DebugMonitorSample(current_time, dataOutSampleKilobits)
		);
		data_out_samples_max_value = max(dataOutSampleKilobits, data_out_samples_max_value);
		
		// DATA IN RATE
		if (array_length(data_in_samples) >= data_rate_samples_max_count) array_shift(data_in_samples);
		var dataInSampleKilobits = max(0, BytesToKilobits(_lastDataInRate));
		array_push(
			data_in_samples,
			new DebugMonitorSample(current_time, dataInSampleKilobits)
		);
		data_in_samples_max_value = max(dataInSampleKilobits, data_in_samples_max_value);
	}
	
	GetMaxPingSamplesValue = function()
	{
		return ping_samples_max_value;
	}
	
	GetMaxPacketLossSamplesValue = function()
	{
		return packet_loss_samples_max_value;
	}
	
	GetMaxDataOutRateSamplesValue = function()
	{
		return data_out_samples_max_value;
	}
	
	GetMaxDataInRateSamplesValue = function()
	{
		return data_in_samples_max_value;
	}
	
	static ResetNetworkDebugMonitoring = function()
	{
		// PING
		ping_samples = [];
		ping_samples_max_value = 1;
		
		// OVER TIME PACKET LOSS COUNT
		packet_loss_samples = [];
		packet_loss_samples_max_value = 1;
		
		// DATA IN RATE
		data_in_samples = [];
		data_in_samples_max_value = 1;
		
		// DATA OUT RATE
		data_out_samples = [];
		data_out_samples_max_value = 1;
	}
}