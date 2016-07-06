<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- SPEC DOESN'T DEFINE IMPLEMENTATION FOR DATA, DATA-ABOUT, AND SORT-AS CHILDREN -->

  <xsl:template match="*[contains(@class, ' svg-d/svg-container ')]">
    <xsl:apply-templates mode="svg-d"/>
  </xsl:template>

  <xsl:template match="svg:*" mode="svg-d">
    <!-- REMOVE ELEMENT PREFIX -->
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="." mode="svg-attributes"/>
      <xsl:apply-templates mode="svg-d"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="svg-attributes">
    <xsl:for-each select="@*">
      <xsl:choose>
        <xsl:when test="namespace-uri() = 'http://www.w3.org/1999/xlink'">
          <!-- PRESERVE ATTRIBUTE NAMESPACE FOR XLINK: -->
          <xsl:copy/>
        </xsl:when>
        <xsl:otherwise>
          <!-- REMOVE OTHER ATTRIBUTE NAMESPACES (IF PRESENT) -->
          <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="comment() | processing-instruction() | text()"
    mode="svg-d">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' svg-d/svgref ')]" mode="svg-d">
    <!-- svgref IS AN EMPTY ELEMENT. ONLY @href IS OF INTEREST. -->
    <xsl:variable name="svg-link" select="@href"/>
    <!-- TO DO (MAYBE): 
          * CHECK VALIDITY OF @href
          * COPY REFERENCED LOCAL SVG FILE TO OUTPUT (OR EMEBED?)
        -->
    <object data="{$svg-link}" type="image/svg+xml"/>
  </xsl:template>

</xsl:stylesheet>