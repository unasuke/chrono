require 'spec_helper'

describe Chrono::Schedule do
  let (:schedule) { Chrono::Schedule.new(source) }

  describe '.new' do
    context 'valid source' do
      subject { Chrono::Schedule.new("\t*\t*\t*\t*\t*\t") }
      it { is_expected.to be_a(Chrono::Schedule) }
    end
    context 'six fields' do
      subject { Chrono::Schedule.new('* * * * * *') }
      it { expect{subject.minutes}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
    context '@yearly' do
      subject { Chrono::Schedule.new('@yearly') }
      it do
        expect(subject.minutes).to eq([0])
        expect(subject.hours).to   eq([0])
        expect(subject.days).to    eq([1])
        expect(subject.months).to  eq([1])
        expect(subject.wdays).to   eq(7.times.to_a)
      end
    end
    context '@annually' do
      subject { Chrono::Schedule.new('@annually') }
      it do
        expect(subject.minutes).to eq([0])
        expect(subject.hours).to   eq([0])
        expect(subject.days).to    eq([1])
        expect(subject.months).to  eq([1])
        expect(subject.wdays).to   eq(7.times.to_a)
      end
    end
    context '@monthly' do
      subject { Chrono::Schedule.new('@monthly') }
      it do
        expect(subject.minutes).to eq([0])
        expect(subject.hours).to   eq([0])
        expect(subject.days).to    eq([1])
        expect(subject.months).to  eq((1..12).to_a)
        expect(subject.wdays).to   eq(7.times.to_a)
      end
    end
    context '@weekly' do
      subject { Chrono::Schedule.new('@weekly') }
      it do
        expect(subject.minutes).to eq([0])
        expect(subject.hours).to   eq([0])
        expect(subject.days).to    eq((1..31).to_a)
        expect(subject.months).to  eq((1..12).to_a)
        expect(subject.wdays).to   eq([0])
      end
    end
    context '@daily' do
      subject { Chrono::Schedule.new('@daily') }
      it do
        expect(subject.minutes).to eq([0])
        expect(subject.hours).to   eq([0])
        expect(subject.days).to    eq((1..31).to_a)
        expect(subject.months).to  eq((1..12).to_a)
        expect(subject.wdays).to   eq(7.times.to_a)
      end
    end
    context '@hourly' do
      subject { Chrono::Schedule.new('@hourly') }
      it do
        expect(subject.minutes).to eq([0])
        expect(subject.hours).to   eq(24.times.to_a)
        expect(subject.days).to    eq((1..31).to_a)
        expect(subject.months).to  eq((1..12).to_a)
        expect(subject.wdays).to   eq(7.times.to_a)
      end
    end
  end

  describe '#minutes' do
    subject { schedule.minutes }
    context "'0 0 * * *'" do
      let (:source){ '0 0 * * *' }
      it { is_expected.to eq [0] }
    end
    context "'59 0 * * *'" do
      let (:source){ '59 0 * * *' }
      it { is_expected.to eq [59] }
    end
    context "'60 0 * * *'" do
      let (:source){ '60 0 * * *' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
  end

  describe '#hours' do
    subject { schedule.hours }
    context "'0 0 * * *'" do
      let (:source){ '0 0 * * *' }
      it { is_expected.to eq [0] }
    end
    context "'0 23 * * *'" do
      let (:source){ '0 23 * * *' }
      it { is_expected.to eq [23] }
    end
    context "'0 24 * * *'" do
      let (:source){ '0 24 * * *' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
  end

  describe '#days' do
    subject { schedule.days }
    context 'day: 1' do
      let (:source){ '0 0 1 * *' }
      it { is_expected.to eq [1] }
    end
    context 'day: 31' do
      let (:source){ '0 0 31 * *' }
      it { is_expected.to eq [31] }
    end
    context 'day" 0' do
      let (:source){ '0 0 0 * *' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
    context 'day: 32' do
      let (:source){ '0 0 32 * *' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
  end

  describe '#months' do
    subject { schedule.months }
    context 'month: 1' do
      let (:source){ '0 0 1 1 *' }
      it { is_expected.to eq [1] }
    end
    context 'month: 12' do
      let (:source){ '0 0 1 12 0' }
      it { is_expected.to eq [12] }
    end
    context 'month: 0' do
      let (:source){ '0 0 1 0 *' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
    context 'month: 13' do
      let (:source){ '0 0 13 0 *' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
  end

  describe '#wdays' do
    subject { schedule.wdays }
    context 'wdays: 0' do
      let (:source){ '0 0 * * 0' }
      it { is_expected.to eq [0] }
    end
    context 'wdays: 6' do
      let (:source){ '0 0 * * 6' }
      it { is_expected.to eq [6] }
    end
    context 'wdays: 7' do
      let (:source){ '0 0 * * 7' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
    context 'wdays: 8' do
      let (:source){ '0 0 * * 8' }
      it { expect{subject}.to raise_error(Chrono::Fields::Base::InvalidField) }
    end
  end
end
