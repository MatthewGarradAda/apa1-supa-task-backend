-- Create the trigger function
CREATE OR REPLACE FUNCTION handle_notification()
RETURNS TRIGGER AS $$
BEGIN
  -- Call your edge function using http request
  SELECT net.http_post(
    'https://uyfwqpzagnashbxqluqj.supabase.co/functions/v1/email_confirmation',
    jsonb_build_object('record', row_to_json(NEW)),
    jsonb_build_object('Content-Type', 'application/json', 'Authorization', 'Bearer ' || current_setting('request.jwt.claim.role'))
  ) AS request_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
CREATE TRIGGER after_insert_notification
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION handle_notification();
