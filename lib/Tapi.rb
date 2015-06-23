class Tapi
	attr_reader :data
	def initialize
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
			config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
			config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
		end
	end

	def search(string,num)
		options = {
			lang: "en",
			result_type: "recent"
		}
		@data = []
		@client.search(string, options).take(num).collect do |tweet|
			@data.push({text: tweet.text})
		end
		return @data
	end

	def build
		freq = {}
		words = @data.join(' ').split(' ')
		words.each { |word| 
			freq[word] += 1 
		}
		@data = freq
	end

	def sanitize
		sym = /[^a-zA-Z\d\s@#]/
		# &amp; can also be a thing
		@newdata = @data.map { |t|

			#remove urls
			tweet = t[:text].gsub(URI.regexp,'')

			#remove symbols, except @
			tweet = tweet.gsub(sym, '')

			#remove newlines
			tweet = tweet.gsub(/\n/,'')

			#remove single characters
			tweet = tweet.gsub(/\s.\s/,' ')

			#downcase
			tweet = tweet.downcase
		}
		@data = @newdata
	end

	@@testdata = ["you ever pop a big blackhead and then get bummed because you no longer have the popping of that blackhead to look forward to? Miss you bud.",
 "http://t.co/uq2T00QCpw #8303 DIAMOND MICRODERMABRASION DERMABRASION FACIAL SKIN CARE PEEL MACHINE BLACKHEAD http://t.co/OiBHXKxrve",
 "TOP DEALS : http://t.co/4KrVWzj1h8 #81655 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #deals… http://t.co/u2DLIz5Lb8",
 "How could you feel nauseated by blackhead extraction videos but able to watch Hannibal without flinching?",
 "Acme of perfection mint york events that tourists ought to blackhead kooky: LtIqUg",
 "http://t.co/XqjK0PjHxv #8098 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne http://t.co/BgyG5Oizmg",
 "GIFTS &amp; DEALS : http://t.co/M9oIgmoNWW #8258 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #ti… http://t.co/umJ6urAzcG",
 "this blackhead scrub is really working",
 "Homemade Pore Strips For DIY Blackhead Removal... http://t.co/hd4I82g874",
 "So his name is is BLACKHEAD...<U+1F602><U+1F602><U+1F602><U+1F480><U+1F480> @DreadedOG",
 "Check This Deal http://t.co/076IKkPcYZ #3594 300 PILATEN blackhead remover,deep cleansing black mud mask nose por… http://t.co/TTmnMQ74n2",
 "#Acne #Treatments JMT Blackhead Pimples Acne Blemish Comedone Needle Extractor Remover Tool NEW http://t.co/2b4YoiMmpQ #SkinCare #Deals",
 "25 YO blackhead removed by niece who screams when it comes out.: '@MARTYROCKSD on Instagram. You guys are are sick!' http://t.co/S0tR7sbnBO",
 "I think I just got blackhead cleanser in my mouth",
 "#Deals &amp; Offers &gt;&gt; http://t.co/ASRSoSYgzI #8172 NV500 Diamond Dermabrasion Skin Care Freckle Fine Line Blackhead … http://t.co/BnWjDbP5nA",
 "#Acne #Treatments 1xpcs Blackhead Comedone Acne Pimple Blemish Extractor Remover Stainless Needles http://t.co/Po7uoUdgq4 #SkinCare #Deals",
 "In so tired I just started to brush my teeth with my face wash scrub- at least my teeth will be blemish and blackhead free",
 "I GOT BLACKHEAD CLEANSER IN MY EYE AND THEM I ACCIDENTALLY PUSHED DOWN THE DRAIN IN THE SINK AND NOW I CANT GET IT BACK UP SO ITS CLOGGED",
 "Want more #pops? Stay tuned for more from Pops! He came in last week for another round of #blackhead… https://t.co/8B2pJu61hL",
 "Murad Blackhead &amp; Pore Clearing Duo http://t.co/I3Q9l7LXjZ",
 "New post: Best Blackhead Extractor Solutions To Clear The Skin . http://t.co/GgxxCqoLjg",
 "I don't know why, but those blackhead removal video compilations are disgusting &amp; gross, but I CANNOT LOOK AWAY..\n#disturbed #SickInTheHead",
 "@kate_schell over here we still have Blackhead Signpost road from where beheaded black heads were on a signpost. o_O",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/S8vTqe5KV2 http://t.co/rVZAOXzOWf",
 "Eddie tried taking out a blackhead on my nose &amp; I woke up looking like rudolf<U+1F621>",
 "@jackboyess I'll wait for Dr. Blackhead Buster to start making YouTube videos",
 "TODAY DEALS : http://t.co/HooSrPgoTo #01905 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #723… http://t.co/LbTLkx79qE",
 "@MincedPineapple nooo but did you see the one with the guy who had a blackhead on his back for 25 years!!",
 "Check out Clearskin® Dual Ended Blackhead Remover via @AvonInsider http://t.co/hCnuT8aKc5",
 "Check out Clearskin® Blackhead Eliminating Daily Astringent via @AvonInsider http://t.co/0HoYrnHSmL",
 "BEST GIFTS http://t.co/vTILbWe2vF #7271 NV500 Diamond Dermabrasion Skin Care Freckle Fine Line Blackhead Lighten Machin #6689\n\n$159.00\nEn…",
 "Organic Face Mask - Blackhead Face Mask- All Natural Face Mask - Clay Face Mask - Blackhead Busting Face Mask - Det… http://t.co/vNbiUluEzu",
 "tmi time of th day;; i popped a blackhead on my nose and it exploded all pver the mirror <U+1F44C>\u{1F3FC}
<U+1F44C>\u{1F3FC}<U+1F44C>\u{1F3FC}",
 "Easy Nose Blackhead Acne Remover Skin Facial Pore Cleaner Toolfor Girl Lady HY http://t.co/lZvqwGamh9 http://t.co/cIeyZWxDit",
 "เหตุผล - BLACKHEAD  【OFFICIAL MV】 http://t.co/CLUYmQG3AU",
 "Hiking in Bonavista yesterday, Brigus today, Blackhead tomorrow. I love Newfoundland! Happy summer solstice!",
 "#Acne #Treatments 3 Pcs Blackhead Whitehead Acne Comedones Blemish Pro Remover Extractor Tool Kit http://t.co/O62KcN0K7S #SkinCare #Deals",
 "Trying out this blackhead thing and seeing how it works<U+1F637> https://t.co/h0qHPZy1hB",
 "BEAUTY DEALS #9119 : http://t.co/jmshQPIjPn 300 PILATEN blackhead remover,deep cleansing black mud mask nose pore… http://t.co/G9EhKM7eKI",
 "Today's Sale Strains for Medical &amp; Retail::: MEDICAL patients - Bahia Blackhead (Hs) $25 eighth (members... http://t.co/4x6htz0o7l",
 "Today's Sale Strains for Medical &amp; Retail:::\n\nMEDICAL patients - Bahia Blackhead (Hs)\n$25 eighth (members &amp;... http://t.co/d2C3QgqzOo",
 "DIAMOND MICRODERMABRASION DERMABRASION FACIAL SKIN CARE PEEL MACHINE BLACKHEAD http://t.co/DtgNQ6QJAW #8516\n\n$85.… http://t.co/gN18PMP094",
 "2pcs Pro Blackhead Comedone Remover Acne Blemish Pimple Extractor Tool PHNP http://t.co/jKkWnT7KPI http://t.co/hD5qQaMCBX",
 "Blackhead blaster!!! Mix a few drops of lemon juice with 1 spoon of sugar and rub gently on your face.",
 "I think I have a blackhead in my ear<U+1F623> it hurts so bad.",
 "My grandma thought my nose piercing hole was a blackhead <U+1F612>",
 "#larocheposay #astrigentlotion #blackpores #blackhead Micro exfoliating astrigent face lotion https://t.co/O0Zdvp35wn",
 "\"A blemish in their white world but yet I'm just a blackhead\"",
 "YOUR DEALS &gt;&gt; http://t.co/mzemH9fCeM #6073 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne\n\n$499… http://t.co/CP0U5083FQ",
 "#Acne #Treatments 5Pcs Blackhead Stainless Needles Extractor Acne Pimple Blemish Remover Useful http://t.co/sWBKaDlZOV #SkinCare #Deals",
 "I added a video to a @YouTube playlist http://t.co/037QmLgmrK Huge blackhead on my thigh! Part 2",
 "I added a video to a @YouTube playlist http://t.co/McgP2hOute WORLD'S OLDEST BIGGEST BLACKHEAD!!! REMOVED REMOVAL EXTRACTION",
 "BEAUTY DEALS : http://t.co/1LrxBNelvi #7920ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #1974… http://t.co/u5qkYRhBIw",
 "my nose is one big blackhead ⚫️<U+1F443>",
 "#SkinCare #Masks Caolion Blackhead Steam Pore Pack 50g All Skin Type Brand New Free Shipping http://t.co/NwOWXHyoCG #Peels #Bestseller",
 "#Acne #Treatments Proactiv + Blackhead Dissolving Gel, 1oz Size, NIB, Exp 1/17! http://t.co/wQopuspT6T #SkinCare #Deals",
 "Hot Deals &amp; Offers &gt;&gt; http://t.co/4RQ5ozSrWc #1249 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Ac… http://t.co/0ZTRDIkbnf",
 "4 Pcs Blackhead Extractor Stainless Steel Acne Needle Tool http://t.co/qLdhsNB6q5",
 "Beauty Deals : http://t.co/cW0uvoKjog #3095 DIAMOND MICRODERMABRASION DERMABRASION FACIAL SKIN CARE PEEL MACHINE BLACKHEAD #5913\n\n$85.01\n…",
 "HOT DEALS http://t.co/pI76dIcqUn #35602 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #8680\n\n$… http://t.co/ZryvGmHEwK",
 "Blackhead blaster: Mix a few drops of lemon juice with 1 spoon of sugar and rub gently on your face.",
 "I liked a @YouTube video from @asboxoffice http://t.co/blyHG7Q4jo Blackhead! Hair Follicle and Sebum Information",
 "I added a video to a @YouTube playlist http://t.co/blyHG7Q4jo Blackhead! Hair Follicle and Sebum Information",
 "Tonight i wanna scrub off my blackhead. Mauuuu picit sama dia.",
 "http://t.co/jOYJLvFUBX #8537 DIAMOND MICRODERMABRASION DERMABRASION FACIAL SKIN CARE PEEL MACHINE BLACKHEAD http://t.co/fjjct78bCV",
 "Health &amp; Beauty : http://t.co/GvY9KOvEPU #775 New High Quality Facial Cleansing Pad Face Blackhead Remover Silico… http://t.co/NXcFGQ0UBk",
 "#Exfoliators #Scrubs Scrub Tool Blackhead Remover Facial Face Skin Care Cleaner Wash Brush Body SPA http://t.co/rxLK7VkTya #SkinCare #Deals",
 "invisible blackhead in my eyebrow, so pardon my glamor",
 "Quick and Easy Blackhead Remedies http://t.co/njwynTxFaw",
 "rip me:\nwent to cottonrose for blackhead removal\ncold, sniffling while being pricked by needles and metallic things",
 "Hot Deals : http://t.co/LuBlRBIBtN #3221 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #deals\n… http://t.co/hAviYxOdj0",
 "#1 Blackhead &amp; Blemish Remover Kit – Equinox Acne Treatment – 5 Professional Surgical… http://t.co/940HOTYLJH http://t.co/eaUCYFbMdm",
 "#1 Blackhead &amp; Blemish Remover Kit - Equinox Acne Treatment - 5 Professional Surgical ... - http://t.co/940HOTYLJH http://t.co/efJIRQtsBY",
 "Beauty Deals : http://t.co/XSFiayEeTf #90560 New High Quality Facial Cleansing Pad Face Blackhead Remover Silicon… http://t.co/4BTPjwnn0s",
 "Beauty &gt;&gt; New High Quality Facial Cleansing Pad Face Blackhead Remover Silicon Brush C-28 New High Quality Facial C… http://t.co/uN0ePsemfU",
 "Beauty : http://t.co/oXNysQ4nkM #9764 Panasonic Pore Suction Spot Clear Skin Care Blackhead Beauty Japan EH2513P-… http://t.co/W6VFe1QfiC",
 "if i were a dermatologist i think i would gain a huge sense of satisfaction from blackhead removal and making things nice again. #ocd",
 "Microdermabrasion with skincare is a good way of exfoliating the dead skin &amp; getting rid of blackhead &amp; whiteheads once a month.",
 "#SkinCare #Masks 5PCS [RedGinseng2+NoseStrip3]PREMIUM Facial Essence Mask+BlackHead PeelOff Mask http://t.co/5v1fDPS1za #Peels #Bestseller",
 "just spent hours watching cyst and blackhead removal videos (:::",
 "#SkinCare #Masks 5PCS [Charcoal2+Nose Strip3] PREMIUM Facial Essence Mask+BlackHead PeelOff Mask http://t.co/X1rbe5LSiG #Peels #Bestseller",
 "Blackhead brumal-salience pertinent to meaningful tally of subject mechanism: cPCuF",
 "Silver Blackhead Comedone Remover Acne Blemish Pimple Extractor Tool\n\nPakistan Easy Pesa : 250 Rs\nWorld wide... http://t.co/FAPguNcPaC",
 "Japan Nose Pack Blackhead Peel Off Pore Face Oil Remover Mask Cleanser kit ladie http://t.co/OrwSQZrnc4 http://t.co/7J8vuBPOnA",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/SgiK9MRWjM http://t.co/I3xs9NnITP",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/6R1TcPjAAF http://t.co/0D84WuUG4Y",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/4ULjrS4Ink http://t.co/FYXFnN9vxc",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/4ULjrS4Ink http://t.co/cVXEwHuQdR",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/6R1TcPjAAF http://t.co/Pt76pXbk5w",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/EqGaDpLAuW http://t.co/uGG6R9jB05",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/EqGaDpLAuW http://t.co/559wycycaC",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/4BqC8D5DGx http://t.co/z8ULtBIlTz",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/4BqC8D5DGx http://t.co/eJoEt1n3iq",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/YQj7cqrKnx http://t.co/asrP7WqWeY",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/dMnkrUyooF http://t.co/3a2n6r3eaA",
 "Just finally popped a blackhead that wouldn't pop for a year <U+1F366><U+1F605>",
 "Blackhead blaster: Mix a few drops of lemon juice with 1 spoon of sugar and rub gently on your face.",
 "I liked a @YouTube video http://t.co/8QpAQ1xMj9 A big blackhead! Dedicated to Colm &amp; all the listeners on RTE, Dublin!",
 "#SkinCare #Masks 5PCS [Cucumber2+Nose Strip3] PREMIUM Facial Essence Mask+BlackHead PeelOff Mask http://t.co/3Yu8bAd6au #Peels #Bestseller",
 "#SkinCare #Masks 5PCS [Aqua2+Nose Strip3]PREMIUM Facial Essence Mask Sheet+BlackHead PeelOff Mask http://t.co/NZ0ABxQDDe #Peels #Bestseller",
 "DIY blackhead remover. Mix and apply to face. Leave on for 10 to 15 minutes before washing off. #iamFLAWLESS https://t.co/oL2e5s8Saw",
 "DIY blackhead remover. Mix and apply to face. Leave on for 10 to 15 minutes before washing off. #iamFLAWLESS http://t.co/EinZ0hRPNA",
 "What exactly is a blackhead? (All will be explained this way &gt;&gt;&gt; http://t.co/9mU61i3fBx) http://t.co/z9m4GIhJsQ",
 "hello, i'm the lancome anon and made an account lol A... — yay for you!! i use two different blackhead removers:... http://t.co/syT2406yBe",
 "#Acne #Treatments Blackhead Pimples Acne Blemish Comedone Needle Extractor Remover Tool?S http://t.co/88rW12hxIt #SkinCare #Deals",
 "I'm scared man #proactive #blackhead (Vine by @churrogod) https://t.co/MTqwjlG1ej",
 "Me myself and i :p\n#instagood \n\n#blueeyes \n#Blackhead \n#goodmorning by fluffyunicorn744 http://t.co/hSOGVFl1Pv",
 "[Tosowoong]4D vibration Pore brush, Foundation puff for make up/Remove blackhead http://t.co/iWQy5c67fb #2922\n\n$5… http://t.co/iO05zB65As",
 "Lol I got Louie spoiling himself. He uses tresemme conditioner/shampoo &amp; leave in conditioner, he has blackhead clearing facewash",
 "Beauty Tips #594 http://t.co/gzP3DpTFBW Panasonic Pore Suction Spot Clear Skin Care Blackhead Beauty Japan EH2513… http://t.co/LCJavRFhMN",
 "http://t.co/4Nc2omvzzi #26733 DIAMOND MICRODERMABRASION DERMABRASION FACIAL SKIN CARE PEEL MACHINE BLACKHEAD #863… http://t.co/5YnAsrpOZ1",
 "St. Ives Blemish &amp; Blackhead Control Apricot Scrub, 6 Oz http://t.co/3PPvStOH3W",
 "post coitus blackhead youtube videos",
 "blackhead popping vvideos....that is my fetish...",
 "#SkinCare #Masks 5PCS [RoyalJelly2+NoseStrip3]PREMIUM Facial Essence Mask+BlackHead PeelOff Mask http://t.co/yBE8ztwK0m #Peels #Bestseller",
 "I added a video to a @YouTube playlist http://t.co/qGWXuHeGGv DIY Blackhead Removal Mask / How to Get Rid of Blackheads",
 "#SkinCare #Masks 5PCS [Vitamin 2+NoseStrip 3] PREMIUM Facial Essence Mask+BlackHead PeelOff Mask http://t.co/obNPVufgUq #Peels #Bestseller",
 "SA New 12 Pcs Blemish Blackhead Extractor Acne Removers Needles Beauty Tools http://t.co/3vqqqqyx7K http://t.co/Z8BTh3FkUF",
 "You the human beach ball “@Armand_FHKABQ: Nigga you look like a blackhead lmfao https://t.co/p4LbQf5Lxl”",
 "Nigga you look like a blackhead lmfao https://t.co/TwsgbPUOmX",
 "I can't go anywhere today... the shame of a giant blackhead!",
 "TODAY DEALS : http://t.co/HooSrPgoTo #01905 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne #684… http://t.co/wwClxwWvMg",
 "BEAUTY TIPs &gt;&gt; http://t.co/LtuDTCb5Gm #6357 Panasonic Pore Suction Spot Clear Skin Care Blackhead Beauty Japan EH… http://t.co/h1fBv7eHig",
 "Skin Tips To Clean &amp; Get Rid Of Blackhead Pores http://t.co/qfz6ZjbQub",
 "Skin Tips To Clean &amp; Get Rid Of Blackhead Pores http://t.co/NHEGIVJNg6",
 "ElishaCoy 3D Spin Cleanser + Blackhead brush + Vita Capsule cleanser is 60% OFF!!!!! Only 48$! This  http://t.co/YTjmN4DtqO",
 "The best BHA to get rid of acne scars http://t.co/eMSt9euy30 http://t.co/m7DgOhL2X6",
 "The best BHA to get rid of acne scars http://t.co/eMSt9euy30 http://t.co/0Kg5bBMOjg",
 "Blackhead",
 "#10: Veluxio Naturals Best Blackhead Remover and Comedone Extractor Tool Kit http://t.co/w81weJRFHw",
 "Wet hair, blackhead nose strip, Vaseline rosy lips and expresssmileatlanta ! #PamperNight <U+1F481>\u{1F3FC}
<U+1F443>\u{1F3FC}<U+1F444><U+1F62C> https://t.co/DrHvZ8x9ug",
 "Pore strips don’t clear pores. They just take the top of the blackhead off, but the rest of it still sits in your pores. Switch to a BHA.",
 "people are gonna think i have a big ass blackhead on my nose <U+1F602>.",
 "@peachytakuya and for blackheads i just use the blackhead eraser and mix it with the continuous control by clean and clear",
 "Viral Video: Man Removes his Blackhead, He got Terrified on what he Discovered http://t.co/g2ZOZNBUCc",
 "#SkinCare #Masks 50ml Black Mud Face Mask Deep Cleaning Skin Blackhead Pore Removal Treatment http://t.co/eHppkOwnsL #Peels #Bestseller",
 "@cara4l  try Garnier blackhead eliminating scrub with charcoal. Sucks oil out without over drying and keeps it nice all day",
 "#Acne #Treatments Blackhead Remover Tool For Acne Facial Pore Pimple Blemish Extractor Needle http://t.co/HPeeRcm8Iz #SkinCare #Deals",
 "#SkinCare #Masks Blackhead Remover Deep Cleansing purifying peel acne black mud face mask SHILLS http://t.co/ZzqpxmFxfd #Peels #Bestseller",
 "SHILLS Blackhead Remover Deep Cleansing Purifying Peel Acne Black Mud Face Mask - Full rea… http://t.co/GQjgMkVNmT http://t.co/XWCmU2ZKmL",
 "Blackhead Remover Cleaner Acne Blemish Needle Pimple Spot Extractor Pin Tool W6 http://t.co/xe01Sb44W3 http://t.co/QS0tSiedyY",
 "http://t.co/WWRcCAkRc3 #1377  NV500 Diamond Dermabrasion Skin Care Freckle Fine Line Blackhead Lighten Machin http://t.co/hqcibX8RNE",
 "Hot Beauty Offers http://t.co/Gwzl1cRfHa #8121 300 PILATEN blackhead remover,deep cleansing black mud mask nose p… http://t.co/Ldob8wINY4",
 "BEAUTY DEALS &gt;&gt; http://t.co/YFRHE076H5 #8312 Panasonic Pore Suction Spot Clear Skin Care Blackhead Beauty Japan E… http://t.co/wNpb0r3USo",
 "#Acne #Treatments Blackhead Pimples L Needle 1pc Remover Tool Blemish Extractor http://t.co/NqV8MDcCzq #SkinCare #Deals",
 "#Lightening #Cream SHILLS Purifying Peel-Off Blackhead Mask Deep Cleaning Acne Effective Comedo http://t.co/tNrdslYLiH #SkinCare #Discount",
 "#Acne #Treatments 2pcs Silicone Blackhead Remover Facial Cleaning Pad Brush Friction Functional http://t.co/lvYvkK66xa #SkinCare #Deals",
 "BEST DEALS &gt;&gt; http://t.co/NAxe82tvGj #9422 ANYMI IPL2000 FOR HOME USE/Hair Removal/Skin Care/Blackhead/Acne http://t.co/732LvejjUU",
 "the stud I bought is too big and the other one in the package makes it look like I have a gigantic blackhead pray for me please",
 "I had a big ass blackhead on my nose for hella months and I JUST popped it Thank god"]

end