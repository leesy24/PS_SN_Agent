# PS_SN_Agent
PS data UDP relay agent by PS's SN(Serial Number) by Processing.

- PSDraw�� SN(Serial Number) interface���� SN+10000�� port�� unicast UDP listen�Ѵ�.
- PS_SN_Agent�� 1024�� �� 1025�� port�� unicast UDP listen�Ѵ�.
- PSDraw�� PS command �� SN�� �߰��� unicast UDP packet�� localhost�� 1024�� port�� �۽��Ѵ�.
- PS_SN_Agent�� 1024�� port�� PSDraw���� ���� unicast UDP packet�� �����Ѵ�.
- PS_SN_Agent�� ���ŵ� PSDraw�� packet���� SN�� PS device�� IP�� ��ȯ�ϰ� PS command packet�� �غ��Ѵ�.
- PS_SN_Agent�� PS device�� IP �� 1024�� port�� PS command packet�� �۽��Ѵ�.
- PS device�� PS command packet�� ���� reply packet�� 1025�� port�� unicast UDP packet���� �۽��Ѵ�.
- PS_SN_Agent�� 1025�� port�� PS device���� ���� unicast UDP packet�� �����Ѵ�.
- PS_SN_Agent�� ���ŵ� PS device�� packet���� source IP�� SN�� �ٲٰ� PSDraw�� port(SN+10000)�� ��ȯ�ϰ� PS reply packet�� �غ��Ѵ�.
- PS_SN_Agent�� PSDraw�� port(SN+10000)�� PS reply packet�� �۽��Ѵ�.
- PSDraw�� SN+10000�� port�� PS_SN_Agent���� ���� unicast UDP packet�� �����Ѵ�.
- PSDraw�� ���ŵ� PS reply packet�� �̿��Ѵ�.


C:\>netstat -a -n -o -p udp

Ȱ�� ����

  ��������  ���� �ּ�              �ܺ� �ּ�              ����            PID
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
