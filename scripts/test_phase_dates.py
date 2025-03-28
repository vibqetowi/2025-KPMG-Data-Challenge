from pipeline.utils.data_mocking import DataMocker

mocker = DataMocker()

# Test 1 - Phase
phase_start, phase_end = mocker.get_phase_dates(101, 1)
print("📦 Phase (101, 1)")
print("Start Date:", phase_start)
print("End Date:", phase_end)

# Test 2 - Engagement
eng_start, eng_end = mocker.get_engagement_dates(101)
print("\n📁 Engagement 101")
print("Start Date:", eng_start)
print("End Date:", eng_end)
