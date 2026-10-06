<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<!-- Ülesanne 8 -->
		<table border="1">
			<!-- Ülesanne 10 -->
			<caption>
				<strong>Kõikide reiside andmed</strong>
			</caption>
			<!-- Ülesanne 10 -->
			<tr>
				<th>Nr</th>
				<th>ID</th>
				<th>Riik</th>
				<th>Kestvus (päeva)</th>
				<th>Transport</th>
				<th>Transpordi hind</th>
				<th>Majutus</th>
				<th>Majutuse hind</th>
				<th>Ekskursioonid</th>
				<th>Ekskursioonide hind</th>
				<th>Muud kulud</th>
				<th>Muude kulude hind</th>
				<th>Reisihind</th>
				<th>Kogumaksumus</th>
				<th>Hinnang</th>
			</tr>
			<xsl:for-each select="reisid/reis">
				<!-- Ülesanne 7 -->
				<xsl:sort select="suund/kestvus" data-type="number" order="descending"/>
				<tr>
					<!-- Ülesanne 9 -->
					<xsl:if test="position() mod 2 = 1">
						<xsl:attribute name="style">background-color:lightblue;</xsl:attribute>
					</xsl:if>
					<xsl:if test="position() mod 2 = 0">
						<xsl:attribute name="style">background-color:lightgreen;</xsl:attribute>
					</xsl:if>
					<td>
						<xsl:value-of select="position()"/>
					</td>
					<td>
						<xsl:value-of select="@id"/>
					</td>
					<td>
						<xsl:value-of select="normalize-space(suund/riik)"/>
					</td>
					<td>
						<xsl:value-of select="suund/kestvus"/>
					</td>
					<td>
						<xsl:value-of select="transport/liik"/>
					</td>
					<td>
						<xsl:value-of select="transport/hind"/> €
					</td>
					<td>
						<xsl:value-of select="majutus/hotell"/>
					</td>
					<td>
						<xsl:value-of select="majutus/hind"/> €
					</td>
					<td>
						<xsl:for-each select="ekskursioonid/ekskursioon">
							<xsl:value-of select="nimi"/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
					</td>
					<td>
						<xsl:value-of select="sum(ekskursioonid/ekskursioon/hind)"/> €
					</td>
					<td>
						<xsl:value-of select="muudKulud/kirjeldus"/>
						
					</td>
					<td>
						<xsl:value-of select="muudKulud/hind"/> €
					</td>
					<td>
						<xsl:value-of select="reisihind"/> €
					</td>
					<!-- Ülesanne 5 -->
					<td>
						<strong>
							<xsl:value-of select="reisihind + transport/hind + majutus/hind + sum(ekskursioonid/ekskursioon/hind) + muudKulud/hind"/> €
						</strong>
					</td>
					<td>
						<xsl:value-of select="hinnang"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<p>
			Reise kokku: <xsl:value-of select="count(reisid/reis)"/>,
			neist lennureise: <xsl:value-of select="count(reisid/reis[transport/liik = 'lennureis'])"/>
		</p>

		<h2>Kõik reisid</h2>

		<xsl:for-each select="reisid/reis">
			<!-- Ülesanne 7 -->
			<xsl:sort select="suund/kestvus" data-type="number" order="descending"/>

			<!-- Ülesanne 1 -->
			<h1>
				<xsl:value-of select="normalize-space(suund/riik)"/>
			</h1>

			<!-- Ülesanne 2 -->
			<ul>
				<li>
					Reis <xsl:value-of select="position()"/> / <xsl:value-of select="last()"/>
					(ID: <xsl:value-of select="@id"/>)
				</li>
				<li>
					Suund:
					<!-- Ülesanne 3 -->
					<ul>
						<li style="background-color:yellow;">
							Riik: <xsl:value-of select="suund/riik"/>
						</li>
						<li style="background-color:yellow;">
							Kestvus: <xsl:value-of select="suund/kestvus"/> päeva
						</li>
					</ul>
				</li>
				<li>
					Riigi algustäht: <xsl:value-of select="substring(suund/riik, 1, 1)"/>
				</li>
				<li>
					Riigi kood: <xsl:value-of select="translate(substring(suund/riik, 1, 3), 'abcdefghijklmnopqrstuvwxyzõäöü', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÕÄÖÜ')"/>
				</li>
				<li>
					Riigi nimes on <xsl:value-of select="string-length(suund/riik)"/> tähte
				</li>
				<li>
					Transport: <xsl:value-of select="transport/liik"/>
					(<xsl:value-of select="transport/hind"/> €)
				</li>
				<li>
					Majutus: <xsl:value-of select="majutus/hotell"/>
					(<xsl:value-of select="majutus/hind"/> €)
				</li>
				<li>
					Ekskursioonid (<xsl:value-of select="count(ekskursioonid/ekskursioon)"/> tk):
					<ul>
						<xsl:for-each select="ekskursioonid/ekskursioon">
							<li>
								<xsl:value-of select="position()"/>. <xsl:value-of select="nimi"/> - <xsl:value-of select="hind"/> €
							</li>
						</xsl:for-each>
					</ul>
				</li>
				<li>
					Muud kulud: <xsl:value-of select="muudKulud/kirjeldus"/>
					(<xsl:value-of select="muudKulud/hind"/> €)
				</li>
				<li>
					Reisihind: <xsl:value-of select="reisihind"/> €
				</li>
				<li>
					Hinnang: <xsl:value-of select="hinnang"/>/10
				</li>
			</ul>

			<!-- Ülesanne 4 -->
			<xsl:if test="suund/kestvus > 7">
				<p>
					<strong style="background-color:orange;">Pikk reis</strong>
				</p>
			</xsl:if>

			<!-- Ülesanne 4 -->
			<xsl:if test="hinnang >= 9">
				<p>
					<strong style="color:green;">Väga hea reis</strong>
				</p>
			</xsl:if>
			<xsl:if test="not(hinnang >= 9)">
				<p>Tavaline reis</p>
			</xsl:if>

			<!-- Ülesanne 5 -->
			<p>
				<strong>Kogumaksumus: </strong>
				<xsl:value-of select="reisihind + transport/hind + majutus/hind + sum(ekskursioonid/ekskursioon/hind) + muudKulud/hind"/> €
			</p>
			<hr/>
		</xsl:for-each>

		<h2>Ainult lennureisid</h2>
		<ul>
			<!-- Ülesanne 6 -->
			<xsl:for-each select="reisid/reis[starts-with(transport/liik, 'lennu')]">
				<!-- Ülesanne 7 -->
				<xsl:sort select="suund/kestvus" order="descending"/>
				<li>
					<strong>
						<xsl:value-of select="suund/riik"/>
					</strong>
					- <xsl:value-of select="suund/kestvus"/> päeva,
					hinnang <xsl:value-of select="hinnang"/>,
					kogumaksumus <xsl:value-of select="reisihind + transport/hind + majutus/hind + sum(ekskursioonid/ekskursioon/hind) + muudKulud/hind"/> €
				</li>
			</xsl:for-each>
		</ul>
	


	</xsl:template>
</xsl:stylesheet>
