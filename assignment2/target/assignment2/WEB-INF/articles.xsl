<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/articles">
  <h2>Available Articles</h2>
  <ul>
    <xsl:for-each select="article">
      <li>
        <a href="article.jsp?id={@id}">
          <xsl:value-of select="title"/>
        </a>
      </li>
    </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>