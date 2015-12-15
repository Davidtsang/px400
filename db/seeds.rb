Domain.create(name: "书法", status: 2)
Domain.create(name: "交互设计", status: 2)
Domain.create(name: "产品设计", status: 2)
Domain.create(name: "修图", status: 2)
Domain.create(name: "创意指导", status: 2)
Domain.create(name: "动态图像设计", status: 2)
Domain.create(name: "动画", status: 2)
Domain.create(name: "包装", status: 2)
Domain.create(name: "化妆艺术", status: 2)
Domain.create(name: "印刷设计", status: 2)
Domain.create(name: "品牌推广", status: 2)
Domain.create(name: "图形(平面)设计", status: 2)
Domain.create(name: "图标设计", status: 2)
Domain.create(name: "图案设计", status: 2)
Domain.create(name: "字体设计", status: 2)
Domain.create(name: "室内设计", status: 2)
Domain.create(name: "家具设计", status: 2)
Domain.create(name: "导演", status: 2)
Domain.create(name: "展览设计", status: 2)
Domain.create(name: "工业设计", status: 2)
Domain.create(name: "布景设计", status: 2)
Domain.create(name: "广告", status: 2)
Domain.create(name: "建筑", status: 2)
Domain.create(name: "手工艺", status: 2)
Domain.create(name: "排版业", status: 2)
Domain.create(name: "插图", status: 2)
Domain.create(name: "摄影", status: 2)
Domain.create(name: "文案", status: 2)
Domain.create(name: "新闻摄影", status: 2)
Domain.create(name: "时尚行业", status: 2)
Domain.create(name: "景观设计", status: 2)
Domain.create(name: "服装设计", status: 2)
Domain.create(name: "涂鸦艺术", status: 2)
Domain.create(name: "游戏设计", status: 2)
Domain.create(name: "漫画", status: 2)
Domain.create(name: "烹饪艺术", status: 2)
Domain.create(name: "玩具设计", status: 2)
Domain.create(name: "珠宝设计", status: 2)
Domain.create(name: "用户界面/用户体验", status: 2)
Domain.create(name: "电影制作", status: 2)
Domain.create(name: "纺织品设计", status: 2)
Domain.create(name: "绘图", status: 2)
Domain.create(name: "绘画", status: 2)
Domain.create(name: "网站开发", status: 2)
Domain.create(name: "网页设计", status: 2)
Domain.create(name: "美术", status: 2)
Domain.create(name: "艺术指导", status: 2)
Domain.create(name: "视觉效果", status: 2)
Domain.create(name: "计算机动画", status: 2)
Domain.create(name: "雕塑", status: 2)
SiteConfig.create(name: "give new user some icode", the_key:"new_users_icode_num", the_value: "10" )

case Rails.env
  when "development"
#fake tags
    fake_tags = ['2d', '3d', 'abstract', 'after effects', 'android', 'animal', 'animals', 'animated', 'animation', 'app', 'apparel', 'apple', 'application', 'architecture', 'arrow', 'art', 'avatar', 'background', 'badge', 'banner', 'bar', 'basketball', 'bear', 'beer', 'bike', 'bird', 'black', 'black and white', 'blog', 'blue', 'book', 'box', 'brand', 'branding', 'brown', 'brush', 'building', 'business', 'business card', 'button', 'buttons', 'c4d', 'calendar', 'calligraphy', 'camera', 'car', 'card', 'cards', 'cartoon', 'cat', 'character', 'character design', 'chart', 'christmas', 'church', 'cinema 4d', 'circle', 'city', 'clean', 'clock', 'cloud', 'clouds', 'coffee', 'collage', 'color', 'colorful', 'colors', 'comic', 'concept', 'corporate', 'cover', 'creative', 'css', 'css3', 'custom', 'cute', 'dark', 'dashboard', 'data', 'debut', 'design', 'digital', 'dog', 'doodle', 'download', 'drawing', 'dribbble', 'ecommerce', 'editorial', 'email', 'event', 'eye', 'face', 'facebook', 'fashion', 'film', 'fire', 'fish', 'flat', 'flat design', 'flower', 'flowers', 'flyer', 'font', 'food', 'football', 'form', 'free', 'freebie', 'fun', 'game', 'geometric', 'gif', 'girl', 'gold', 'gradient', 'graph', 'graphic', 'graphic design', 'graphics', 'gray', 'green', 'grey', 'grid', 'grunge', 'gui', 'halloween', 'hand', 'hand drawn', 'hand lettering', 'handlettering', 'handmade', 'happy', 'header', 'health', 'heart', 'holiday', 'home', 'homepage', 'house', 'html', 'icon', 'icons', 'identity', 'illustration', 'illustrator', 'infographic', 'ink', 'interface', 'invitation', 'invite', 'ios', 'ios7', 'ipad', 'iphone', 'kids', 'label', 'landing', 'landing page', 'layout', 'letter', 'lettering', 'letterpress', 'letters', 'light', 'line', 'lines', 'list', 'login', 'logo', 'logo design', 'logotype', 'love', 'mac', 'magazine', 'man', 'map', 'mark', 'marketing', 'mascot', 'menu', 'metal', 'minimal', 'mobile', 'mockup', 'modern', 'money', 'monogram', 'monster', 'moon', 'motion', 'mountain', 'movie', 'music', 'nature', 'navigation', 'new', 'orange', 'packaging', 'page', 'paint', 'painting', 'paper', 'pattern', 'pen', 'pencil', 'personal', 'phone', 'photo', 'photography', 'photoshop', 'pink', 'pixel', 'player', 'portfolio', 'portrait', 'poster', 'print', 'process', 'product', 'profile', 'psd', 'purple', 'quote', 'rebound', 'red', 'redesign', 'render', 'responsive', 'restaurant', 'retro', 'ribbon', 'robot', 'script', 'sea', 'search', 'shadow', 'shapes', 'shirt', 'shop', 'sign', 'simple', 'site', 'sketch', 'skull', 'sky', 'slider', 'snow', 'soccer', 'social', 'space', 'sport', 'sports', 'stamp', 'star', 'stars', 'store', 'summer', 'sun', 'symbol', 't-shirt', 'template', 'text', 'texture', 'theme', 'time', 'travel', 'tree', 'tshirt', 'tv', 'twitter', 'type', 'typeface', 'typo', 'typography', 'ui', 'ui design', 'user', 'user interface', 'ux', 'vector', 'video', 'vintage', 'wallpaper', 'water', 'watercolor', 'weather', 'web', 'web design', 'webdesign', 'website', 'wedding', 'white', 'widget', 'wip', 'wireframe', 'woman', 'wood', 'wordpress', 'yellow']

    fake_tags.each do |t|
      Label.create(name: t)
    end

    fake_skills =['.net', '2d', '2d animation', '3d', '3d animation', '3d design', '3d modeling', '3d modelling', '3ds max', 'adobe', 'adobe after effects', 'adobe creative suite', 'adobe dreamweaver', 'adobe flash', 'adobe illustrator', 'adobe indesign', 'adobe photoshop', 'adobe suite', 'advertising', 'after effect', 'after effects', 'ai', 'ajax', 'android', 'angularjs', 'animation', 'app', 'app design', 'app development', 'apparel design', 'application design', 'apps', 'architecture', 'art', 'art direction', 'art director', 'artist', 'asp.net', 'autocad', 'axure', 'blogging', 'book design', 'bootstrap', 'brand', 'brand design', 'brand development', 'brand identity', 'brand strategy', 'branding', 'brochure design', 'c', 'calligraphy', 'cartoon', 'cartooning', 'character design', 'cinema 4d', 'cms', 'coding', 'comics', 'communication', 'compositing', 'concept', 'concept art', 'concept design', 'concept development', 'copywriting', 'corel draw', 'coreldraw', 'corporate design', 'corporate identity', 'creative', 'creative direction', 'creative director', 'creativity', 'css', 'css 3', 'css3', 'data visualization', 'design', 'design thinking', 'designer', 'designing', 'developer', 'development', 'digital', 'digital art', 'digital design', 'digital illustration', 'digital marketing', 'digital painting', 'digital photography', 'draw', 'drawing', 'dreamweaver', 'drupal', 'e-commerce', 'ecommerce', 'editing', 'editorial', 'editorial design', 'email marketing', 'fashion', 'film', 'final cut pro', 'fine art', 'fireworks', 'flash', 'flash animation', 'flat design', 'front end', 'front end development', 'front-end', 'front-end developer', 'front-end development', 'frontend', 'frontend development', 'game design', 'gimp', 'graffiti', 'graphic', 'graphic design', 'graphic designer', 'graphic designing', 'graphics', 'graphics design', 'gui', 'gui design', 'hand lettering', 'html', 'html  css', 'html 5', 'html css', 'html5', 'htmlcss', 'ia', 'icon', 'icon design', 'iconography', 'icons', 'identity', 'identity design', 'illustration', 'illustrations', 'illustrator', 'ilustration', 'indesign', 'industrial design', 'infographic', 'infographics', 'information architecture', 'information design', 'inkscape', 'interaction', 'interaction design', 'interactive', 'interactive design', 'interface', 'interface design', 'interior design', 'internet marketing', 'ios', 'ios design', 'ios development', 'ipad', 'iphone', 'java', 'javascript', 'joomla', 'jquery', 'js', 'layout', 'layout design', 'less', 'lettering', 'letterpress', 'lightroom', 'logo', 'logo design', 'logo designer', 'logos', 'logotype', 'magento', 'marketing', 'maya', 'mobile', 'mobile app', 'mobile app design', 'mobile apps', 'mobile design', 'mobile development', 'mobile ui', 'motion', 'motion design', 'motion graphic', 'motion graphics', 'music', 'mysql', 'node.js', 'objective-c', 'online marketing', 'package design', 'packaging', 'packaging design', 'painter', 'painting', 'photo', 'photo editing', 'photo manipulation', 'photo retouching', 'photographer', 'photography', 'photomanipulation', 'photoshop', 'php', 'pixel art', 'poster', 'poster design', 'posters', 'premiere', 'premiere pro', 'print', 'print design', 'printmaking', 'product', 'product design', 'product development', 'product management', 'programming', 'project management', 'prototyping', 'ps', 'publication design', 'python', 'rails', 'responsive', 'responsive design', 'responsive web design', 'retouching', 'ruby', 'ruby on rails', 'sass', 'screen printing', 'seo', 'sketch', 'sketching', 'social media', 'social media marketing', 'sql', 'storyboarding', 'strategy', 't-shirt design', 'type', 'type design', 'typography', 'ui', 'ui  ux', 'ui design', 'ui designer', 'ui ux', 'uiux', 'uiux design', 'usability', 'user experience', 'user experience design', 'user interface', 'user interface design', 'user research', 'ux', 'ux design', 'ux designer', 'uxui', 'vector', 'vector art', 'vector illustration', 'vfx', 'video', 'video editing', 'video production', 'videography', 'visual design', 'visual identity', 'watercolor', 'web', 'web design', 'web designer', 'web designing', 'web developer', 'web development', 'web-design', 'webdesign', 'website', 'website design', 'website development', 'websites', 'wireframe', 'wireframes', 'wireframing', 'wordpress', 'writing', 'xhtml']
    fake_skills.each do |t|
      Skill.create(name: t)
    end

#def def icode to user


    icode =Icode.new
    icode.generate_code
    icode.save

    admin = User.create!(name: "Example User",
                         email: "123@kejike.com",
                         location: "San Francisco, CA",
                         password: "12345678",
                         user_role: "admin",
                         icode: icode.code,
                         password_confirmation: "12345678")

#give 10 icode to admin
    10.times do
      icode =Icode.new
      icode.generate_code
      icode.user_id = admin.id
      icode.save

    end

    skills = Skill.all.to_ary

    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@kejike.com"
      password = "12345678"
      location= "#{Faker::Address.city}, #{Faker::Address.state}"
      domain_id = rand(50)

      icode =Icode.new
      icode.generate_code
      icode.save

      user = User.create!(name: name,
                          email: email,
                          password: password,
                          domain_1_id: domain_id,
                          location: location,
                          user_role: 'artist',
                          icode: icode.code,
                          password_confirmation: password)

      10.times do
        icode =Icode.new
        icode.generate_code
        icode.user_id = user.id
        icode.save
      end

      #random a 1~5 skills
      skills_number = rand(5)

      while skills_number > 0
        UsersTag.create(user_id: user.id, tag_id: skills[rand(skills.count)].id)
        skills_number -= 1

      end
    end

    users = User.order(:created_at).take(7)

    labels = Label.all.to_ary


    50.times do

      users.each do |user|
        image = File.open(Dir.glob(File.join(Rails.root, 'public/fake-image/', '*')).sample)
        desciption = Faker::Lorem.sentence(7)
        title = Faker::Lorem.sentence(4)[0..80]
        domain_id = rand(50)
        work =user.works.create!(desciption: desciption, image: image, title: title, domain_id: domain_id)
        #timeline
        Timeline.create(user_id: user.id, work_id: work.id, act: "new")
        image.close

        #add 1~5 tags to work
        tags_number = rand(5)

        while tags_number > 0
          tag_id = labels[rand(labels.count)].id

          if WorksTag.where(work_id: work.id, tag_id: tag_id).any?
            loop do
              tag_id = labels[rand(labels.count)].id
              break unless WorksTag.where(work_id: work.id, tag_id: tag_id).any?

            end
          end

          WorksTag.create(work_id: work.id, tag_id: tag_id)
          tags_number -= 1

        end
      end
    end

# Following relationships
    users = User.all
    user = users.first
    following = users[2..50]
    followers = users[3..40]
    following.each { |followed| user.follow(followed) }
    followers.each { |follower| follower.follow(user) }

end




