<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:variable name="vaiksed" select="'abcdefghijklmnopqrsšzžtuvwõäöüxy'"/>
	<xsl:variable name="suured" select="'ABCDEFGHIJKLMNOPQRSŠZŽTUVWÕÄÖÜXY'"/>


	<xsl:template name="kogumaksumus">
		<xsl:value-of select="reisihind + transport/hind + majutus/hind + sum(ekskursioonid/ekskursioon/hind) + muudKulud/hind"/>
	</xsl:template>

	<xsl:template match="/">
		<p>
			Reise kokku: <xsl:value-of select="count(reisid/reis)"/>,
			neist lennureise: <xsl:value-of select="count(reisid/reis[transport/liik = 'lennureis'])"/>
		</p>

		<h2>Lennureisid (sorteeritud hinnangu järgi)</h2>

		<xsl:for-each select="reisid/reis[starts-with(transport/liik, 'lennu')]">
			<xsl:sort select="hinnang" data-type="number" order="descending"/>

			<h1>
				<xsl:value-of select="normalize-space(suund/riik)"/>
			</h1>

			<ul>
				<li>
					Reis <xsl:value-of select="position()"/> / <xsl:value-of select="last()"/>
					(ID: <xsl:value-of select="@id"/>)
				</li>
				<li>
					Suund:
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
					Riigi kood: <xsl:value-of select="translate(substring(suund/riik, 1, 3), $vaiksed, $suured)"/>
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

			<xsl:if test="not(suund/kestvus &lt;= 7)">
				<p>
					<strong style="background-color:orange; padding:2px 6px;">Pikk reis</strong>
				</p>
			</xsl:if>

			<xsl:variable name="vagaHea" select="hinnang &gt;= 9"/>
			<xsl:if test="$vagaHea = true()">
				<p>
					<strong style="color:green;">Väga hea reis</strong>
				</p>
			</xsl:if>
			<xsl:if test="$vagaHea = false()">
				<p>Tavaline reis</p>
			</xsl:if>

			<p>
				<strong>Kogumaksumus: </strong>
				<xsl:call-template name="kogumaksumus"/> €
			</p>
			<hr/>
		</xsl:for-each>

		<h2>Kõik reisid</h2>
		<table border="1" cellpadding="5">
			<thead>
				<tr style="background-color:#333; color:white;">
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
					<th>Reisihind</th>
					<th>Kogumaksumus</th>
					<th>Hinnang</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="reisid/reis">
					<xsl:sort select="hinnang" data-type="number" order="descending"/>
					<tr>
						<xsl:attribute name="style">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 1">background-color:lightblue;</xsl:when>
								<xsl:otherwise>background-color:lightgreen;</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
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
							<xsl:value-of select="muudKulud/hind"/> €
						</td>
						<td>
							<xsl:value-of select="reisihind"/> €
						</td>
						<td>
							<strong>
								<xsl:call-template name="kogumaksumus"/> €
							</strong>
						</td>
						<td>
							<xsl:value-of select="hinnang"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>
