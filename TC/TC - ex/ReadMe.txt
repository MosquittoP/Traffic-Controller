Traffic Controller Exercise

사용 툴 : Modelsim(Verilog HDL)

남북(NS), 동서(EW)의 교차로가 있는 교통신호제어기 설계 시뮬레이션입니다.
각 방향 모두 같은 정지 시간과 통행시간을 가지며 신호가 바뀌는 시간 5초 간격입니다.
황색 신호는 없다고 가정하고, 녹색 -> 적색, 적색 -> 녹색으로 바뀝니다.
설계는 Mealy machine을 기반하였으며, 신호 변화는 Mod-5 카운터를 사용했습니다.
실제 시뮬레이션 시 test bench 파일인 tb - TC.v를 Run하면 됩니다.