if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
      
    # Specify your transformation logic here
    data = data[(data['passenger_count'] != 0)]
    data = data[(data['trip_distance'] != 0)]
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    data.columns = ['vendor_id', 'lpep_pickup_datetime', 'lpep_dropoff_datetime', 'store_and_fwd_flag', 'rate_code_id', 'pu_location_id', 'do_location_id','passenger_count', 'trip_distance', 'fare_amount', 'extra', 'mta_tax','tip_amount', 'tolls_amount', 'ehail_fee', 'improvement_surcharge','total_amount', 'payment_type', 'trip_type', 'congestion_surcharge', 'lpep_pickup_date']
    # print(data.vendor_id.unique())

    return data


@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'
    
@test
def test_output2(output, *args) -> None:
    assert output[output['passenger_count'] == 0].shape[0] == 0, 'passenger_count has a value less than 1'  

@test
def test_output3(output, *args) -> None:
    assert output[output['trip_distance'] == 0].shape[0] == 0, "trip_distance has a value less than 1"    

@test
def test_output4(output, *args) -> None:
    assert output[output['vendor_id'].isin([2, 1])].shape == output.shape, "trip_distance has a value less than 1"    