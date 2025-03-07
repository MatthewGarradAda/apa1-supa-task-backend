-- Create the trigger function
CREATE OR REPLACE FUNCTION handle_notification()
RETURNS TRIGGER AS $$
BEGIN
  -- Call your edge function using http request
  PERFORM net.http_post(
    'https://uyfwqpzagnashbxqluqj.supabase.co/functions/v1/email_confirmation',
    jsonb_build_object('record', row_to_json(NEW))
  ) AS request_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
CREATE TRIGGER after_insert_notification
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION handle_notification();
