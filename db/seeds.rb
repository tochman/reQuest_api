# frozen_string_literal: true

# Create Users
5.times do |n|
  User.create( email: "user#{n}@mail.com", password: "password#{n}" )
end

# Create requests
title_part_1 = ['I need help with', 'Could someone help me with', 'Requesting assist with']
title_part_2 = ['changing tyres',
                'moving a body',
                'install washing machine',
                'football penalites practice',
                'learning Chinese',
                'fortifying the western front',
                'building storm barricades',
                'becoming Batman',
                'learning to drive an excavator',
                'erradicating the rats in my house',
                'my javelin technique',
                'moving a big rock, like really big']

description_part_1 = ['Yeah, so I have this problem here...',
                      'It is quite embarrasing really...',
                      "I've needed this for some time now.",
                      'You will be my superhero!',
                      "I am in a panic, I can't do this myself.",
                      "I don't even know where to start!"]
days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday tomorrow asap]
users = User.all
50.times do
  users.sample.requests.create(title: "#{title_part_1.sample} #{title_part_2.sample}",
                               description: "#{description_part_1.sample} Will #{days.sample} work for you? #{Faker::Lorem.paragraphs(number: rand(0..3)).join(" ")}",
                               reward: rand(0..10),
                               long: 12 + rand * 6,
                               lat: 57.7 + rand * 4,
                               category: Request.categories.keys.sample)
end
requests = Request.all
# Create Offers

75.times do
  request = requests.sample
  helper = (users - [request.requester]).sample
  status = Offer.statuses.keys.sample
  helper.offers.create(request: request, status: status)
  if status == 'accepted'
    requests -= [request]
    request.status = %w[active active completed].sample
  end
end

# Create conversations
messages = ['Are you sure we can do this?',
            'Is this against the law?',
            'Come on, it will be fun!',
            "I don't know about this...",
            'I think the reward is too low for this undertaking',
            'Maybe we should schedule for another day',
            'I know this other guy with a cousine that has a friend that recently bought a thing that would totally help with this',
            'We need to get this done ASAP or we are in trouble',
            'SomeBODY once told me... doing things like this is not very smart',
            'I really appreciate this, man!',
            'Have we met before?',
            'Let me think about this for a sec...']

200.times do
  offer = Offer.all.sample
  sender = [offer.helper, offer.request.requester].sample
  offer.conversation.messages.create(content: messages.sample, sender: sender)
end
