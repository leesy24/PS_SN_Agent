# PS_SN_Agent
PS data UDP relay agent by PS's SN(Serial Number) by Processing.

- PSDraw의 SN(Serial Number) interface에서 SN+10000번 port로 unicast UDP listen한다.
- PS_SN_Agent는 1024번 및 1025번 port로 unicast UDP listen한다.
- PSDraw는 PS command 에 SN를 추가한 unicast UDP packet을 localhost의 1024번 port로 송신한다.
- PS_SN_Agent의 1024번 port로 PSDraw에서 보낸 unicast UDP packet을 수신한다.
- PS_SN_Agent는 수신된 PSDraw의 packet에서 SN을 PS device의 IP로 변환하고 PS command packet을 준비한다.
- PS_SN_Agent는 PS device의 IP 및 1024번 port에 PS command packet을 송신한다.
- PS device는 PS command packet에 대한 reply packet을 1025번 port로 unicast UDP packet으로 송신한다.
- PS_SN_Agent는 1025번 port로 PS device에서 보낸 unicast UDP packet을 수신한다.
- PS_SN_Agent는 수신된 PS device의 packet에서 source IP를 SN로 바꾸고 PSDraw의 port(SN+10000)로 변환하고 PS reply packet을 준비한다.
- PS_SN_Agent는 PSDraw의 port(SN+10000)에 PS reply packet을 송신한다.
- PSDraw의 SN+10000번 port로 PS_SN_Agent에서 보낸 unicast UDP packet을 수신한다.
- PSDraw는 수신된 PS reply packet을 이용한다.


C:\>netstat -a -n -o -p udp

활성 연결

  프로토콜  로컬 주소              외부 주소              상태            PID
	...
  UDP    0.0.0.0:1025           *:*                                    14364
  ...
  UDP    127.0.0.1:1024         *:*                                    14364
  ...
  UDP    127.0.0.1:10123        *:*                                    13596
  UDP    127.0.0.1:10886        *:*                                    10788
  UDP    127.0.0.1:11221        *:*                                    1280
  UDP    127.0.0.1:12233        *:*                                    5780
  ...
