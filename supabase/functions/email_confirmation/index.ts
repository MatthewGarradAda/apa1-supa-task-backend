import nodemailer from 'npm:nodemailer@6.9.10';
import {EMAIL_USER, EMAIL_APP_PASSWORD} from "./config.ts"

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: EMAIL_USER,
    pass: EMAIL_APP_PASSWORD
  }
});

export const sendEmail = async (to: string, subject: string, content: string, html: string = "") => {
  const mailOptions = {
    from: EMAIL_USER,
    to,
    subject,
    text: content,
    html
  };

  const info = await transporter.sendMail(mailOptions);
  return info;
};


Deno.serve(async (req) => {
  const { email, id } = await req.json();

  try {
    if (!email || !id) {
      throw new Error("validation failed")
    }
    const to = email
    const subject = "Thank you for your order"
    const content = `Your order ${id} has been confirmed!`
    await sendEmail(to, subject, content)

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: "Email sent successfully" 
      }),
      { 
        headers: { "Content-Type": "application/json" },
        status: 200 
      }
    );
  } catch (error) {
    console.log(error)
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: (error instanceof Error) ? error.message : error 
      }),
      { 
        headers: { "Content-Type": "application/json" },
        status: 500 
      }
    );
  }
});



