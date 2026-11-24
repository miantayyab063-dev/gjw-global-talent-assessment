// Candidate-facing UI translation dictionary. Unknown strings are intentionally left in English.
(()=>{
 const l=document.documentElement.lang;
 if(!['ur','ar'].includes(l))return;
 const dict={
 'Sign In':['سائن اِن','تسجيل الدخول'], 'Register':['رجسٹر کریں','إنشاء حساب'],
 'Dashboard':['ڈیش بورڈ','لوحة التحكم'], 'Logout':['لاگ آؤٹ','تسجيل الخروج'],
 'Create Candidate Account':['امیدوار کا اکاؤنٹ بنائیں','إنشاء حساب للمرشح'],
 'Secure Registration':['محفوظ رجسٹریشن','التسجيل الآمن'], 'Results & Feedback':['نتائج اور رائے','النتائج والملاحظات'],
 'Welcome back':['خوش آمدید','مرحباً بعودتك'], 'Create account':['اکاؤنٹ بنائیں','إنشاء حساب'],
 'Register & Verify Email':['رجسٹر کریں اور ای میل کی تصدیق کریں','التسجيل والتحقق من البريد الإلكتروني'],
 'My Applications':['میری درخواستیں','طلباتي'], 'Application History':['درخواستوں کی تاریخ','سجل الطلبات'],
 '+ New Application':['نئی درخواست','طلب جديد'], 'Open Application':['درخواست کھولیں','فتح الطلب'],
 'New Candidate Application':['نئی درخواست','طلب مرشح جديد'], 'Create Application':['درخواست بنائیں','إنشاء طلب'],
 'Start Application':['درخواست شروع کریں','بدء الطلب'], 'Upload CV':['سی وی اپ لوڈ کریں','رفع السيرة الذاتية'],
 'National ID / Passport':['قومی شناختی کارڈ / پاسپورٹ','الهوية الوطنية / جواز السفر'],
 'Professional Profile':['پیشہ ورانہ پروفائل','الملف المهني'], 'Save Profile':['پروفائل محفوظ کریں','حفظ الملف'],
 'Start Recording':['ریکارڈنگ شروع کریں','بدء التسجيل'], 'Super Coupon':['سپر کوپن','القسيمة الخاصة'],
 'Submit Payment Proof':['ادائیگی کا ثبوت جمع کریں','إرسال إثبات الدفع'],
 'Payment approval required before continuing':['آگے بڑھنے کے لیے ادائیگی کی منظوری ضروری ہے','يلزم اعتماد الدفع قبل المتابعة'],
 'Actual bank transaction ID':['اصل بینک ٹرانزیکشن نمبر','رقم المعاملة البنكية الفعلي'],
 'Payment screenshot':['ادائیگی کا اسکرین شاٹ','لقطة شاشة الدفع'],
 'Submit for Admin Verification':['ایڈمن کی تصدیق کے لیے جمع کرائیں','إرسال للتحقق الإداري'],
 'Request an exception':['استثنا کی درخواست','طلب استثناء'],
 'Start / Continue Technical Test':['تکنیکی ٹیسٹ شروع یا جاری رکھیں','بدء أو متابعة الاختبار الفني'],
 'Technical MCQ Test':['تکنیکی سوالات','أسئلة الاختيار من متعدد التقنية'],
 'Submit Final Assessment':['حتمی جانچ جمع کریں','إرسال التقييم النهائي'],
 'Full name':['مکمل نام','الاسم الكامل'], 'Mobile':['موبائل','الهاتف المحمول'],
 'Address':['پتہ','العنوان'], 'Languages':['زبانیں','اللغات'],
 'Expected salary':['متوقع تنخواہ','الراتب المتوقع'], 'Courses & Certifications':['کورسز اور سرٹیفکیٹس','الدورات والشهادات'],
 'Technical skills':['تکنیکی صلاحیتیں','المهارات التقنية'], 'Employment & Experience':['ملازمت اور تجربہ','العمل والخبرة'],
 'Assessment Payment':['اسیسمنٹ کی ادائیگی','دفع رسوم التقييم'],
 'Scheduled Live Interview':['طے شدہ براہ راست انٹرویو','المقابلة المباشرة المجدولة'],
 'Join Video Interview':['ویڈیو انٹرویو میں شامل ہوں','الانضمام إلى المقابلة المرئية'],
 'Identity Verification':['شناخت کی تصدیق','التحقق من الهوية'],
 'Verified Final Scorecard':['تصدیق شدہ نتیجہ','بطاقة النتائج المعتمدة'],
 'Feedback & improvement areas':['رائے اور بہتری کے پہلو','الملاحظات ومجالات التحسين']
 };
 const i=l==='ur'?0:1;
 const walker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT);
 let n;while(n=walker.nextNode()){
  const parent=n.parentElement;if(!parent||['SCRIPT','STYLE','TEXTAREA','OPTION'].includes(parent.tagName))continue;
  const x=n.nodeValue.trim();if(dict[x])n.nodeValue=n.nodeValue.replace(x,dict[x][i]);
 }
 document.querySelectorAll('button,input').forEach(el=>{
  if(el.type==='submit'&&el.value&&dict[el.value])el.value=dict[el.value][i];
 });
})();
