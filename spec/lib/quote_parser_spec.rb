require 'rails_helper'
require 'quote_parser'

describe QuoteParser do
  let(:raw) {}
  subject { QuoteParser.new.parse(raw: raw) }

  # GENERAL CASE
  context 'incase of quote is identified by “”' do
    let!(:raw) { ' “The most painful thing is losing yourself in the process of loving someone too much, and forgetting that you are special too.”
― Ernest Hemingway' }

    it { expect(subject.title).to eq 'The most painful thing is losing yourself in the process of loving someone too much, and forgetting that you are special too.' }
    it { expect(subject.author).to eq 'Ernest Hemingway' }
  end

  context 'incase of quote is identified by ''' do
    let!(:raw) { "'Don’t waste your time on jealousy; sometimes you’re ahead, sometimes you’re behind… the race is long and in the end, it’s only with yourself.' - Baz Luhrmann" }

    it { expect(subject.title).to eq "Don’t waste your time on jealousy; sometimes you’re ahead, sometimes you’re behind… the race is long and in the end, it’s only with yourself." }
    it { expect(subject.author).to eq 'Baz Luhrmann' }
  end

  context 'incase of string start with "' do
    context 'and quote is identified by ""' do
      let!(:raw) { "\"No one is saying that you've broken any laws, Mr. President... We're just saying it's a little weird that you didn't have to.\" -- John Oliver on PRISM" }

      it { expect(subject.title).to eq "No one is saying that you've broken any laws, Mr. President... We're just saying it's a little weird that you didn't have to." }
      it { expect(subject.author).to eq 'John Oliver on PRISM' }
    end

    # special case
    # @todo: Pass this spec
    context 'but quote section isn\'t only bounded by ""' do
      let!(:raw) { '"If the girl had been worth having she’d have waited for you?" No, sir, the girl really worth having won’t wait for anybody. - F. Scott Fitzgerald, This Side of Paradise' }

      it { expect(subject.title).to eq '"If the girl had been worth having she’d have waited for you?" No, sir, the girl really worth having won’t wait for anybody.' }
      it { expect(subject.author).to eq 'F. Scott Fitzgerald, This Side of Paradise' }
    end
  end

  ## A Special character separator is used
  context 'incase of quote and author separated by -' do
    context 'and only one character is used' do
      let!(:raw) { 'Don’t mistake my kindness for weakness. I am kind to everyone, but when someone is unkind to me, weak is not what you are going to remember about me. - Al Capone' }

      it { expect(subject.title).to eq 'Don’t mistake my kindness for weakness. I am kind to everyone, but when someone is unkind to me, weak is not what you are going to remember about me.' }
      it { expect(subject.author).to eq 'Al Capone' }
    end

    context 'and numerous characters are used' do
      let!(:raw) { "\"You know what 'family values' means? That's hating the same people your grandfather hated.\" ---Robert Anton Wilson" }

      it { expect(subject.title).to eq "You know what 'family values' means? That's hating the same people your grandfather hated." }
      it { expect(subject.author).to eq 'Robert Anton Wilson' }
    end
  end

  context 'incase of quote and author separated by —' do
    let!(:raw) { 'Many people die at twenty five and aren’t buried until they are seventy five. — Benjamin Franklin.' }

    it { expect(subject.title).to eq 'Many people die at twenty five and aren’t buried until they are seventy five.' }
    it { expect(subject.author).to eq 'Benjamin Franklin' }
  end

  context 'incase of quote and author separated by ~' do
    let!(:raw) { "Anyway, no drug, not even alcohol, causes the fundamental ills of society. If we're looking for the source of our troubles, we shouldn't test people for drugs, we should test them for stupidity, ignorance, greed and love of power. ~P.J. O'Rourke" }

    it { expect(subject.title).to eq "Anyway, no drug, not even alcohol, causes the fundamental ills of society. If we're looking for the source of our troubles, we shouldn't test people for drugs, we should test them for stupidity, ignorance, greed and love of power." }
    it { expect(subject.author).to eq "P.J. O'Rourke" }
  end

  # @todo: Pass this spec
  context 'incase string has \n' do
    context 'and quote and author are separated by \n' do
      let!(:raw) { "Have I not destroyed my enemy when I have made friends with him?

Abraham Lincoln." }

      it { expect(subject.title).to eq "Have I not destroyed my enemy when I have made friends with him?" }
      it { expect(subject.author).to eq 'Abraham Lincoln' }
    end

    context 'and \n are just random' do
      let!(:raw) { '"Every normal man must be tempted at times to spit upon his hands, hoist the black flag, and begin slitting throats." -HL Mencken


' }
      it { expect(subject.title).to eq "Every normal man must be tempted at times to spit upon his hands, hoist the black flag, and begin slitting throats." }
      it { expect(subject.author).to eq 'HL Mencken' }
    end
  end

  # @todo: Pass this spec
  context 'incase author and quote is separated by .' do
    let!(:raw) { "Be soft. Do not let the world make you hard. Do not let the pain make you hate. Do not let the bitter steal your sweetness. Take pride that even though the rest of the world may disagree you still believe it to be a beautiful place. Kurt Vonnegut" }

    it { expect(subject.title).to eq "Be soft. Do not let the world make you hard. Do not let the pain make you hate. Do not let the bitter steal your sweetness. Take pride that even though the rest of the world may disagree you still believe it to be a beautiful place." }
    it { expect(subject.author).to eq 'Kurt Vonnegut' }
  end

  ## SPECIAL CASE FOR AUTHOR
  context 'incase author is somebody i know' do
    context 'and author is separated by special character -' do
      let!(:raw) { '"sometimes people forget that money is a tool not a goal" - My Mom' }

      it { expect(subject.title).to eq 'sometimes people forget that money is a tool not a goal' }
      it { expect(subject.author).to eq 'My Mom' }
    end

    # @todo: Pass this spec
    context "but author isn't separated by special character" do
      let!(:raw) { "As I lay dying, don't let me hear you cry. This is my big day, don't ruin it for me\"  Told to me by my mother." }

      it { expect(subject.title).to eq "As I lay dying, don't let me hear you cry. This is my big day, don't ruin it for me" }
      it { expect(subject.author).to eq 'Told to me by my mother' }
    end
  end

  # @todo: Pass this spec
  context 'incase author section has special chanter ""' do
    let!(:raw) { '"Life is pain, Highness. Anyone who says differently is selling something." - Westley, "The Princess Bride"' }

    it { expect(subject.title).to eq 'Life is pain, Highness. Anyone who says differently is selling something.' }
    it { expect(subject.author).to eq 'Westley, "The Princess Bride"' }
  end

  context 'incase author has Jr.' do
    let!(:raw) { "\"I just think it's good to be confident. If I'm not on my team why should anybody else be?\" - Robert Downey Jr." }

    it { expect(subject.title).to eq "I just think it's good to be confident. If I'm not on my team why should anybody else be?" }
    it { expect(subject.author).to eq 'Robert Downey Jr.' }
  end

  context 'incase their is no author' do
    let!(:raw) { '"The human brain starts working the moment you are born and never stops until you stand up to speak in public."' }

    it { expect(subject.title).to eq 'The human brain starts working the moment you are born and never stops until you stand up to speak in public.' }
    it { expect(subject.author).to eq '' }
  end

  context 'incase author section has various special characters' do
    # "Nonconformity, right..." - House M.D.
    let!(:raw) { '"Take wrong turns. Talk to strangers. Open unmarked doors. And if you see a group of people in a field, go find out what they are doing. Do things without always knowing how they\'ll turn out. ... " -- Randall Munroe, xkcd: volume 0 ' }

    it { expect(subject.title).to eq "Take wrong turns. Talk to strangers. Open unmarked doors. And if you see a group of people in a field, go find out what they are doing. Do things without always knowing how they'll turn out. ..." }
    it { expect(subject.author).to eq 'Randall Munroe, xkcd: volume 0' }
  end

  context 'incase author is separated by () at the end of string' do
    # Patriotism is nothing but loyalty to real estate, real estate that has been conquered 800 different times by 800 different regimes with 800 different cultures. But each time it’s just the best. - House M.D. - “Risky Business”
    # "A hero can be anyone. Even a man doing something as simple and reassuring as putting a coat around a little boy's shoulders to let him know that the world hadn't ended." -Bruce Wayne, the dark knight rises-
    # "To die will be an awfully big adventure." - Peter Pan (or J.M. Barrie)
    let!(:raw) { "A reader lives a thousand lives before he dies. The man who never reads lives only one. (George R.R. Martin)" }

    it { expect(subject.title).to eq "A reader lives a thousand lives before he dies. The man who never reads lives only one." }
    # @todo: Pass this spec
    it { expect(subject.author).to eq 'George R.R. Martin' }
  end

  ## AUTHOR ON START OF STRING

  # @todo: Pass this spec
  context 'incase author is on start of string & separated by :' do
    # Steve Jobs: When you’re young, you look at television...
    let!(:raw) { "Kurt Cobain: \"If you're a sexist, racist, homophobe, or basically an arsehole, don't buy this CD. I don't care if you like me, I hate you.\"" }

    it { expect(subject.title).to eq "If you're a sexist, racist, homophobe, or basically an arsehole, don't buy this CD. I don't care if you like me, I hate you." }
    it { expect(subject.author).to eq 'Kurt Cobain' }
  end

  ## VERY SPECIAL CASE

  # @todo: Pass this spec
  context 'incase random " is in string' do
    let!(:raw) { "Just because you're offended, doesn't mean you're right.\" - Ricky Gervais" }

    it { expect(subject.title).to eq "Just because you're offended, doesn't mean you're right." }
    it { expect(subject.author).to eq 'Ricky Gervais' }
  end

  # @todo: Pass this spec
  context 'incase random number at the beginning of string' do
    let!(:raw) { " # 38.        “God is a comedian, playing to an audience too afraid to laugh.”
  Voltaire " }

    it { expect(subject.title).to eq "God is a comedian, playing to an audience too afraid to laugh." }
    it { expect(subject.author).to eq 'Voltaire' }
  end

  context 'incase author and quote are so attached' do
    let!(:raw) { 'An anecdote has it that when Phillip II sent a message to Sparta saying "if I enter Laconia, I will raze Sparta", the Spartans responded with the single, terse reply: "If."' }

    it { expect(subject.title).to eq 'An anecdote has it that when Phillip II sent a message to Sparta saying "if I enter Laconia, I will raze Sparta", the Spartans responded with the single, terse reply: "If."' }
    it { expect(subject.author).to eq '' }
  end

  # @todo: Pass this spec
  context 'incase of unusual random text' do
    let!(:raw) { 'Uuuuuuuuuuur Ahhhhrrr Uhrrr Ahhhhhhrrr Aaaaarhg.... -Chewbacca' }

    it { expect(subject.title).to eq '' }
    it { expect(subject.author).to eq '' }
  end

  # @todo: Pass this spec
  context 'incase of incomplete quote' do
    let!(:raw) { "\"Life asked Death: 'Why do people love me but hate you?' Death responded:" }

    it { expect(subject.title).to eq '' }
    it { expect(subject.author).to eq '' }
  end

  context 'incase of string ending on ...' do
    context 'and is a quote' do
      let!(:raw) { "So you think I'm a loser? Just because I have a stinking job that I hate, a family that doesn't respect me, a whole city that curses the day I was born? Well, that may mean loser to you, but let me tell you something..." }

      it { expect(subject.title).to eq "So you think I'm a loser? Just because I have a stinking job that I hate, a family that doesn't respect me, a whole city that curses the day I was born? Well, that may mean loser to you, but let me tell you something..." }
      it { expect(subject.author).to eq '' }
    end

    # @todo: Pass this spec
    context "and isn't a quote" do
      # 'My collection of more than 300 quotes from books, movies, interviews, tv shows...'
      let!(:raw) { 'Patton Oswalt on the Boston Bombings...' }

      it { expect(subject.title).to eq '' }
      it { expect(subject.author).to eq '' }
    end
  end

  # @todo: Pass this spec
  context 'incase of random text' do
    raws = [
      '31 chilling quotes',
      'One of all my all time favorite quotes',
      'George Orwell in London, 1941',
      'Ashton Kutcher on romance in the digital age'
    ]

    raws.each do |r|
      let!(:raw) { r }

      it { expect(subject.title).to eq '' }
      it { expect(subject.author).to eq '' }
    end
  end

  context 'incase of string ending on .' do
    context 'and is a quote' do
      let!(:raw) { "Just because you know someone would wait for you forever doesn't mean you can let them wait that long." }

      it { expect(subject.title).to eq "Just because you know someone would wait for you forever doesn't mean you can let them wait that long." }
      it { expect(subject.author).to eq '' }
    end

    # @todo: Pass this spec
    context 'and is not a quote' do
      let!(:raw) { "Bill Cosby on African Americans." }

      it { expect(subject.title).to eq '' }
      it { expect(subject.author).to eq '' }
    end
  end

  # @todo: Pass this spec
  context 'A special case' do
    let!(:raw) { "My philosophy is: It's none of my business what people say of me and think of me. I am what I am and I do what I do. I expect nothing and accept everything. And it makes life so much easier. Anthony Hopkins"}

    it { expect(subject.title).to eq "It's none of my business what people say of me and think of me. I am what I am and I do what I do. I expect nothing and accept everything. And it makes life so much easier" }
    it { expect(subject.author).to eq 'Anthony Hopkins' }
  end
end
