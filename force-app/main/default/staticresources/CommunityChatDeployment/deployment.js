(function () {
  function Ba(a) {
    switch (a) {
      case "'":
        return "\x26#39;";
      case "\x26":
        return "\x26amp;";
      case "\x3c":
        return "\x26lt;";
      case "\x3e":
        return "\x26gt;";
      case '"':
        return "\x26quot;";
      case "\u00a9":
        return "\x26copy;";
      case "\u2028":
        return "\x3cbr\x3e";
      case "\u2029":
        return "\x3cp\x3e";
      default:
        return a;
    }
  }
  function l() {}
  function t() {}
  function ka(a) {
    l.prototype.init.call(this, a, l.TYPE.STANDARD);
  }
  function la(a) {
    m[a] || (m[a] = new ka(a));
    return m[a];
  }
  function S(a, b) {
    l.prototype.init.call(this, b + "_" + a, l.TYPE.AGENT);
  }
  function K(a, b) {
    var c = b + "_" + a;
    m[c] || (m[c] = new S(a, b));
    return m[c];
  }
  function T(a, b) {
    t.prototype.init.call(this, a, b);
  }
  function U(a, b) {
    t.prototype.init.call(this, a, b);
  }
  function p(a) {
    l.prototype.init.call(this, a, l.TYPE.INVITE);
    this.active = !1;
    this.filterLogic = null;
    this.rules = {};
    this.autoRejectTimeout = this.inviteTimeout = this.inviteDelay = this.ruleTree = null;
  }
  function u(a) {
    m[a] || (m[a] = new p(a));
    return m[a];
  }
  function z(a, b, c, e, d, g, B, x) {
    t.prototype.init.call(this, a, b);
    this.hasInviteAfterAccept = g;
    this.hasInviteAfterReject = B;
    this.rejectTime = x;
    null !== f.getCssAnimation(b) || "Custom" == c
      ? (this.renderer = new p.RENDERER[c].renderClass(
          a,
          b,
          p.START_POSITION[e],
          p.END_POSITION[d]
        ))
      : (this.renderer = new p.RENDERER.Appear.renderClass(
          a,
          b,
          p.START_POSITION[e],
          p.END_POSITION[d]
        ));
  }
  function C(a) {
    return u(a) ? u(a).getTracker() : null;
  }
  function r() {}
  function I(a, b, c, e) {
    r.prototype.init.call(this, a, b, c, e);
  }
  function J(a, b, c, e) {
    r.prototype.init.call(this, a, b, null, e);
  }
  function L(a, b, c, e) {
    r.prototype.init.call(this, a, b, null, e);
  }
  function D(a, b, c, e) {
    D.prototype.init.call(this, a, b, null, null);
  }
  function n() {}
  function M(a, b, c, e, d) {
    n.prototype.init.call(this, a, b, c, e, d);
  }
  function N(a, b, c, e, d) {
    n.prototype.init.call(this, a, b, c, e, d);
  }
  function V(a, b, c, e, d) {
    n.prototype.init.call(this, a, b, c, e, d);
  }
  function E(a) {
    ma++;
    if (1e3 < ma)
      throw Error("Error processing rule filter logic, preventing recursion");
    for (var b = 0, c = 0, e = 0; e < a.length; e++)
      "(" == a.charAt(e) ? c++ : ")" == a.charAt(e) && c--,
        "," == a.charAt(e) && 1 == c && (b = e);
    if (0 == a.indexOf("AND("))
      return (
        (c = E(a.substring(4, b))),
        (a = E(a.substring(b + 1, a.length - 1))),
        new W(c, a)
      );
    if (0 == a.indexOf("OR("))
      return (
        (c = E(a.substring(3, b))),
        (a = E(a.substring(b + 1, a.length - 1))),
        new X(c, a)
      );
    if (0 == a.indexOf("NOT("))
      return (c = E(a.substring(4, a.length - 1))), new Y(c);
    if (!isNaN(parseInt(a, 10))) return new Z(parseInt(a, 10));
    throw Error("Encountered unexpected character in filter logic");
  }
  function y() {}
  function Z(a) {
    this.ruleId = a;
    y.prototype.init.call(this, null, null);
  }
  function W(a, b) {
    y.prototype.init.call(this, a, b);
  }
  function X(a, b) {
    y.prototype.init.call(this, a, b);
  }
  function Y(a) {
    y.prototype.init.call(this, a, null);
  }
  function Ca(a, b, c, e) {
    var d = document.createElement("div");
    d.id = "liveagent_invite_button_" + a;
    var g = document.createElement("img");
    g.style.cursor = "pointer";
    g.style.position = "absolute";
    g.style.right = "-20px";
    g.style.top = "-20px";
    g.src =
      f.addPrefixToURL(k.contentServerUrl, k.urlPrefix, !0) + "/images/x.png";
    f.addEventListener(g, "click", function () {
      h.rejectChat(a);
    });
    d.appendChild(g);
    g = document.createElement("img");
    g.style.cursor = "pointer";
    g.style.clear = "right";
    g.src = b;
    g.width = c;
    g.height = e;
    f.addEventListener(g, "click", function () {
      h.startChat(a);
    });
    d.appendChild(g);
    document.body.appendChild(d);
    return d;
  }
  function na(a, b, c) {
    "undefined" == typeof c && (c = !0);
    this.getLabel = function () {
      return a;
    };
    this.getValue = function () {
      return b;
    };
    this.getDisplayToAgent = function () {
      return c;
    };
    var e = new aa();
    this.getMapper = function () {
      return e;
    };
    this.doKnowledgeSearch = !1;
    this.getDoKnowledgeSearch = function () {
      return this.doKnowledgeSearch;
    };
    this.setDoKnowledgeSearch = function () {
      this.doKnowledgeSearch = !0;
    };
  }
  function aa() {
    var a = [],
      b = [];
    this.getEntityMaps = function () {
      return a;
    };
    this.getTranscriptFields = function () {
      return b;
    };
  }
  function oa(a, b, c, e, d) {
    this.getEntityName = function () {
      return a;
    };
    this.getFieldName = function () {
      return b;
    };
    this.getFastFill = function () {
      return c;
    };
    this.getAutoQuery = function () {
      return e;
    };
    this.getExactMatch = function () {
      return d;
    };
  }
  function pa(a) {
    this.saveToTranscript = "";
    this.showOnCreate = !1;
    this.linkToEntityField = this.linkToEntityName = "";
    var b = new qa();
    this.getEntityName = function () {
      return a;
    };
    this.getSaveTranscript = function () {
      return this.saveTranscript;
    };
    this.getShowOnCreate = function () {
      return this.showOnCreate;
    };
    this.getLinkToEntityName = function () {
      return this.linkToEntityName;
    };
    this.getLinkToEntityField = function () {
      return this.linkToEntityField;
    };
    this.getEntityMapper = function () {
      return b;
    };
    this.setSaveTranscript = function (a) {
      this.saveTranscript = a;
    };
    this.setShowOnCreate = function (a) {
      this.showOnCreate = a;
    };
    this.setLinkToEntityName = function (a) {
      this.linkToEntityName = a;
    };
    this.setLinkToEntityField = function (a) {
      this.linkToEntityField = a;
    };
  }
  function qa() {
    var a = [];
    this.getEntityFieldsMaps = function () {
      return a;
    };
  }
  function ra(a, b, c, e, d) {
    this.getFieldName = function () {
      return a;
    };
    this.getLabel = function () {
      return b;
    };
    this.getDoFind = function () {
      return c;
    };
    this.getIsExactMatch = function () {
      return e;
    };
    this.getDoCreate = function () {
      return d;
    };
  }
  function O() {
    if (!sa) {
      sa = !0;
      f.log("DOM is ready. Setting up environment.");
      null == v.getOref() && v.setOref(document.referrer);
      null == v.getVisitCount() && v.setVisitCount(1);
      if (window._laq)
        for (var a = 0; a < window._laq.length; a++)
          window._laq[a].call(window);
      q.connection.setCallback("liveagent._.handlePing");
      ta();
    }
  }
  function ta() {
    var a = [],
      b = {};
    ba && (b.chatted = 1);
    w
      ? ((b.sid = w), f.log("Reusing existing session."))
      : (a.push(new q.Noun("VisitorId")), f.log("Requesting new session."));
    var c = {
      buttonIds: "[" + ua() + "]",
      updateBreadcrumb: 1,
      urlPrefix: k.urlPrefix
    };
    k.needEstimatedWaitTime && (c.needEstimatedWaitTime = 1);
    a.push(new q.Noun("Settings", c));
    q.connection.send(a, b);
  }
  function va() {
    null !== P && clearTimeout(P);
    P = window.setTimeout(Da, Q ? 0 : k.pingRate);
  }
  function wa(a, b) {
    b.endpointUrl && a.setEndpoint(b.endpointUrl);
    b.prechatUrl && a.setPrechat(b.prechatUrl);
    b.language && a.setLanguage(b.language);
    a.setOnlineState(b.isAvailable);
    b.estimatedWaitTime && a.setEstimatedWaitTime(b.estimatedWaitTime);
  }
  function Da() {
    if (q.connection.isRunning())
      if (null == w || Q) (Q = !1), ta();
      else {
        f.log("Pinging server to keep presence");
        P = null;
        var a = {};
        a.sid = w;
        ba && (a.chatted = 1);
        a.r = new Date().getMilliseconds();
        var b = { ids: "[" + ua() + "]" };
        k.needEstimatedWaitTime && (b.needEstimatedWaitTime = 1);
        b = [new q.Noun("Availability", b)];
        q.connection.send(b, a);
      }
  }
  function ca() {
    f.log("Disconnecting from Live Agent");
    q.connection.setIsRunning(!1);
    for (var a in m) m.hasOwnProperty(a) && m[a].setOnlineState(!1);
  }
  function ua() {
    var a = [],
      b = {},
      c;
    for (c in m)
      m.hasOwnProperty(c) && m[c].getType() == l.TYPE.STANDARD && (b[c] = m[c]);
    for (var e in b) a.push(e);
    var b = {},
      d;
    for (d in m)
      m.hasOwnProperty(d) && m[d].getType() == l.TYPE.AGENT && (b[d] = m[d]);
    for (e in b) a.push(e);
    d = {};
    for (var g in m)
      m.hasOwnProperty(g) && m[g].getType() == l.TYPE.INVITE && (d[g] = m[g]);
    for (e in d) a.push(e);
    e = "";
    for (g = 0; g < a.length; g++) (e += a[g]), g < a.length - 1 && (e += ",");
    return e;
  }
  function xa(a, b, c, e) {
    document.cookie = "liveagent_chatted\x3d1;path\x3d/;";
    ba = !0;
    var d;
    d = "deployment_id\x3d" + k.deploymentId;
    d = d + "\x26org_id\x3d" + k.orgId;
    d += "\x26button_id\x3d";
    d += a;
    c && ((d += "\x26agent_id\x3d"), (d += c));
    e && (d += "\x26do_fallback\x3d1");
    d += "\x26session_id\x3d";
    d += w;
    a = c ? m[c + "_" + a].getEndpoint(d) : m[a].getEndpoint(d);
    c = "height\x3d" + k.chatWindowHeight;
    c = c + ",width\x3d" + k.chatWindowWidth;
    c += ",menubar\x3dno";
    c += ",toolbar\x3dno";
    c += ",location\x3dno";
    c += ",personalbar\x3dno";
    c += ",scrollbars\x3dyes";
    c += ",resizable\x3dyes";
    window.open("", b, c);
    Ea(b, a);
  }
  function Ea(a, b) {
    function c(a, b, c) {
      var e = document.createElement("input");
      e.name = b;
      e.value = c;
      a.appendChild(e);
    }
    var e = v.getVisitCount();
    null == e && (e = "0");
    var d = document.createElement("form");
    d.style.display = "none";
    c(d, "deploymentId", k.deploymentId);
    c(d, "orgId", k.orgId);
    c(d, "vc", e);
    c(d, "sid", w);
    c(d, "ptid", v.getPermanentId());
    c(d, "det", f.jsonEncode(ya));
    c(d, "oref", v.getOref());
    c(d, "pages", f.jsonEncode(A.getPages()));
    c(d, "sessionStart", new Date().getTime() - A.getSessionStart());
    c(d, "ent", f.jsonEncode(za));
    da && c(d, "visitorName", da);
    d.method = "POST";
    d.action = b;
    d.target = a;
    document.body.appendChild(d);
    d.submit();
  }
  function ea(a) {
    a
      ? f.log("Server Warning: " + a)
      : f.log("Server sent an anoymous warning.");
  }
  function Aa(a) {
    a ? f.log("Server Error: " + a) : f.log("Server responded with an error.");
  }
  if (!window.liveAgentDeployment) {
    window.liveAgentDeployment = !0;
    var h = {};
    window.liveagent && (h = window.liveagent);
    window.liveagent = h;
    var f = {
        getCookie: function (a) {
          var b = document.cookie,
            c = b.indexOf(a + "\x3d");
          if (-1 == c) return null;
          c += (a + "\x3d").length;
          a = b.indexOf(";", c);
          -1 == a && (a = b.length);
          return b.substring(c, a);
        },
        setCookie: function (a, b, c) {
          a = a + "\x3d" + b + ";";
          c &&
            ((c = new Date()),
            c.setFullYear(c.getFullYear() + 10),
            (a += "expires\x3d" + c.toGMTString() + ";"));
          document.cookie = a + "path\x3d/;";
        },
        addEventListener: function (a, b, c) {
          if (a.addEventListener) a.addEventListener(b, c, !1);
          else if (a.attachEvent) a.attachEvent("on" + b, c, !1);
          else throw Error("Could not add event listener");
        },
        log: function (a) {
          R &&
            window.console &&
            window.console.log &&
            window.console.log("LIVE AGENT: " + a);
        },
        logGroupStart: function (a) {
          R &&
            window.console &&
            (window.console.group
              ? window.console.groupCollapsed("LIVE AGENT: " + a)
              : f.log(a));
        },
        logGroupEnd: function () {
          R &&
            window.console &&
            window.console.group &&
            window.console.groupEnd();
        },
        getLanguage: function () {
          return "undefined" != typeof window.navigator.language
            ? window.navigator.language
            : "undefined" != typeof window.navigator.userLanguage
            ? window.navigator.userLanguage
            : "";
        },
        arrayHasItem: function (a, b) {
          if (Array.prototype.indexOf) return -1 < a.indexOf(b);
          for (var c = 0; c < a.length; c++) if (a[c] == b) return !0;
        },
        jsonEncode: function (a, b, c) {
          function e(a) {
            g.lastIndex = 0;
            return g.test(a)
              ? '"' +
                  a.replace(g, function (a) {
                    var b = f[a];
                    return "string" === typeof b
                      ? b
                      : "\\u" +
                          ("0000" + a.charCodeAt(0).toString(16)).slice(-4);
                  }) +
                  '"'
              : '"' + a + '"';
          }
          function d(a, b) {
            var c,
              g,
              f,
              B,
              x = k,
              n,
              h = b[a];
            h &&
              "object" === typeof h &&
              "function" === typeof h.toJSON &&
              (h = h.toJSON(a));
            "function" === typeof m && (h = m.call(b, a, h));
            switch (typeof h) {
              case "string":
                return e(h);
              case "number":
                return isFinite(h) ? String(h) : "null";
              case "boolean":
              case "null":
                return String(h);
              case "object":
                if (!h) return "null";
                k += l;
                n = [];
                if ("[object Array]" === Object.prototype.toString.apply(h)) {
                  B = h.length;
                  for (c = 0; c < B; c += 1) n[c] = d(c, h) || "null";
                  f =
                    0 === n.length
                      ? "[]"
                      : k
                      ? "[\n" + k + n.join(",\n" + k) + "\n" + x + "]"
                      : "[" + n.join(",") + "]";
                  k = x;
                  return f;
                }
                if (m && "object" === typeof m)
                  for (B = m.length, c = 0; c < B; c += 1)
                    "string" === typeof m[c] &&
                      ((g = m[c]),
                      (f = d(g, h)) && n.push(e(g) + (k ? ": " : ":") + f));
                else
                  for (g in h)
                    Object.prototype.hasOwnProperty.call(Object(h), g) &&
                      (f = d(g, h)) &&
                      n.push(e(g) + (k ? ": " : ":") + f);
                f =
                  0 === n.length
                    ? "{}"
                    : k
                    ? "{\n" + k + n.join(",\n" + k) + "\n" + x + "}"
                    : "{" + n.join(",") + "}";
                k = x;
                return f;
            }
          }
          if ("undefined" !== typeof window.JSON)
            return window.JSON.stringify(a, b, c);
          if (void 0 === a || null === a) return "null";
          var g = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
            f = {
              "\b": "\\b",
              "\t": "\\t",
              "\n": "\\n",
              "\f": "\\f",
              "\r": "\\r",
              '"': '\\"',
              "\\": "\\\\"
            },
            x,
            k = "",
            l = "",
            m = b;
          if ("number" === typeof c) for (x = 0; x < c; x += 1) l += " ";
          else "string" === typeof c && (l = c);
          if (
            b &&
            "function" !== typeof b &&
            ("object" !== typeof b || "number" !== typeof b.length)
          )
            throw Error("Error during JSON.stringify");
          return d("", { "": a });
        },
        jsonDecode: function (a) {
          a = String(a);
          if ("undefined" !== typeof window.JSON) return window.JSON.parse(a);
          var b = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
          b.lastIndex = 0;
          b.test(a) &&
            (a = a.replace(b, function (a) {
              return "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4);
            }));
          if (
            /^[\],:{}\s]*$/.test(
              a
                .replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@")
                .replace(
                  /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
                  "]"
                )
                .replace(/(?:^|:|,)(?:\s*\[)+/g, "")
            )
          )
            return eval("(" + a + ")");
          throw Error("Error during JSON.parse");
        },
        getCssAnimation: function (a) {
          var b = ["Webkit", "Moz", "O", "ms", "Khtml"];
          if (void 0 !== a.style.animationName) return "";
          for (var c = 0; c < b.length; c++)
            if (void 0 !== a.style[b[c] + "AnimationName"])
              return b[c].toLowerCase();
          return null;
        },
        addPrefixToURL: function (a, b, c) {
          if (!f.isEmpty(a) && !f.isEmpty(b) && 0 !== a.indexOf(b)) {
            c && (b = f.escapeToHtml(b));
            var e = /(https?:\/\/)(.*)/i;
            c = a.replace(e, "$1");
            a = a.replace(e, "$2");
            b = b.replace(e, "$2");
            a = c + b + "/" + a;
          }
          return a;
        },
        getDomainFromUrl: function (a) {
          if (f.isEmpty(a)) return "";
          var b;
          fa || (fa = document.createElement("a"));
          b = fa;
          b.href = a;
          a = a.match(/:(\d+)/g);
          b =
            b.protocol + "//" + b.hostname ||
            window.location.protocol + "//" + window.location.hostname;
          return a ? b + a[0] : b;
        },
        isEmpty: function (a) {
          return null === a || void 0 === a || "" === a;
        },
        escapeToHtml: function (a) {
          return null === a || void 0 === a || "" === a
            ? ""
            : (a = a.replace(/[&<>"'\u00a9\u2028\u2029]/g, Ba));
        },
        isValidEntityId: function (a) {
          return (
            a && "string" === typeof a && (18 === a.length || 15 === a.length)
          );
        },
        getKeyPrefix: function (a) {
          return this.isValidEntityId(a) ? a.substr(0, 3) : null;
        },
        isOrganizationId: function (a) {
          return "00D" === this.getKeyPrefix(a);
        },
        isDeploymentId: function (a) {
          return "572" === this.getKeyPrefix(a);
        },
        trim: function (a) {
          return (
            (a && a.replace(/^[\s\u0000-\u0020]*|[\s\u0000-\u0020]*$/g, "")) ||
            ""
          );
        }
      },
      fa,
      v = {
        getVisitCount: function () {
          var a = parseInt(f.getCookie("liveagent_vc"), 10);
          return isNaN(a) ? null : a;
        },
        getOref: function () {
          return f.getCookie("liveagent_oref");
        },
        getPermanentId: function () {
          var a = f.getCookie("liveagent_ptid");
          return null != a ? a : "";
        },
        hasCookieConsent: function (a) {
          var b = [];
          return (
            0 > ["liveagent_ptid", "liveagent_oref"].indexOf(a) ||
            0 > b.indexOf(window.location.host)
          );
        },
        setVisitCount: function (a) {
          f.setCookie("liveagent_vc", a, !0);
        },
        setOref: function (a) {
          if (this.hasCookieConsent("liveagent_oref"))
            return f.setCookie("liveagent_oref", a, !0);
        },
        setPermanentId: function (a) {
          this.hasCookieConsent("liveagent_ptid") &&
            f.setCookie("liveagent_ptid", a, !0);
        }
      },
      A = new (function () {
        function a() {
          return window.localStorage
            ? window.localStorage
            : window.sessionStorage;
        }
        function b() {
          var a = document.createElement("div");
          a.style.display = "none";
          document.body.appendChild(a);
          a.id = "liveagent_userdata_provider";
          a.addBehavior("#default#userData");
          a.load("liveagent");
          return {
            getItem: function (b) {
              return a.getAttribute(b);
            },
            setItem: function (b, c) {
              a.setAttribute(b, c);
              a.save("liveagent");
            },
            removeItem: function (b) {
              a.removeAttribute(b);
              a.save("liveagent");
            }
          };
        }
        function c() {
          var a = {};
          return {
            getItem: function (b) {
              return a[b];
            },
            setItem: function (b, c) {
              a[b] = c;
            },
            removeItem: function (b) {
              delete a[b];
            }
          };
        }
        function e() {
          g.setItem(d.SESSION_ID, w);
          g.setItem(d.PAGE_COUNT, "0");
          g.setItem(d.SESSION_START, new Date().getTime().toString());
        }
        var d = {
          SESSION_ID: "liveAgentSid",
          PAGE_COUNT: "liveAgentPc",
          SESSION_START: "liveAgentStart",
          PAGE: "liveAgentPage_",
          PAGE_TIME: "liveAgentPageTime_"
        };
        a.isSupported = function () {
          try {
            if (window.localStorage || window.sessionStorage) {
              var a = window.localStorage
                ? window.localStorage
                : window.sessionStorage;
              a.setItem("liveAgentTestKey", "1");
              a.removeItem("liveAgentTestKey");
              return !0;
            }
            return !1;
          } catch (b) {
            return !1;
          }
        };
        b.isSupported = function () {
          return document.createElement("div").addBehavior;
        };
        var g;
        g = a.isSupported() ? a() : b.isSupported() ? b() : c();
        this.init = function () {
          if (g.getItem(d.SESSION_ID)) {
            if (g.getItem(d.SESSION_ID) != w) {
              g.removeItem(d.SESSION_START);
              for (
                var a = g.getItem(d.PAGE_COUNT), b = 25 > a ? 0 : a - 25;
                b < a;
                b++
              )
                g.removeItem(d.PAGE + b), g.removeItem(d.PAGE_TIME + b);
              e();
            }
          } else e();
          a = parseInt(g.getItem(d.PAGE_COUNT), 10);
          25 <= a &&
            (g.removeItem(d.PAGE + (a - 25)),
            g.removeItem(d.PAGE_TIME + (a - 25)));
          g.setItem(d.PAGE_COUNT, (a + 1).toString());
          g.setItem(d.PAGE + a.toString(), window.location.href);
          g.setItem(d.PAGE_TIME + a.toString(), new Date().getTime());
        };
        this.getPageCount = function () {
          return parseInt(g.getItem(d.PAGE_COUNT), 10);
        };
        this.getSessionStart = function () {
          return g.getItem(d.SESSION_START);
        };
        this.getPages = function () {
          for (
            var a = [], b = this.getPageCount(), c = 25 > b ? 0 : b - 25;
            c < b;
            c++
          )
            a.unshift({
              location: g.getItem(d.PAGE + c.toString()),
              time: (
                new Date().getTime() -
                parseInt(g.getItem(d.PAGE_TIME + c.toString()), 10)
              ).toString()
            });
          return a;
        };
        this.getCurrentPage = function () {
          return g.getItem(d.PAGE + (this.getPageCount() - 1).toString());
        };
        this.clear = function () {
          g.clear();
        };
      })();
    l.TYPE = { STANDARD: "STANDARD", INVITE: "INVITE", AGENT: "AGENT" };
    l.EVENT = {
      BUTTON_AVAILABLE: "BUTTON_AVAILABLE",
      BUTTON_UNAVAILABLE: "BUTTON_UNAVAILABLE",
      BUTTON_ACCEPTED: "BUTTON_ACCEPTED",
      BUTTON_REJECTED: "BUTTON_REJECTED"
    };
    l.prototype.init = function (a, b) {
      this.buttonId = a;
      this.type = b;
      this.onlineState = null;
      this.estimatedWaitTime = -1;
      this.trackers = [];
      this.language = this.prechat = this.endpoint = null;
    };
    l.prototype.getType = function () {
      return this.type;
    };
    l.prototype.getOnlineState = function () {
      return this.onlineState;
    };
    l.prototype.setOnlineState = function (a) {
      this.onlineState = a;
      for (var b = 0; b < this.trackers.length; b++)
        this.trackers[b].setState(a);
    };
    l.prototype.getEstimatedWaitTime = function () {
      return this.estimatedWaitTime;
    };
    l.prototype.setEstimatedWaitTime = function (a) {
      this.estimatedWaitTime = a;
    };
    l.prototype.addTracker = function (a) {
      this.trackers.push(a);
    };
    l.prototype.setPrechat = function (a) {
      this.prechat = a;
    };
    l.prototype.setEndpoint = function (a) {
      this.endpoint = a;
    };
    l.prototype.getEndpoint = function (a) {
      function b() {
        var b = k.contentServerUrl,
          c = k.urlPrefix;
        if (null == b)
          throw Error(
            "You cannot call liveagent.startChat until the asynchronous call to liveagent.init has completed!"
          );
        k.contentServerUrl = f.addPrefixToURL(b, c, !0);
        b = this.endpoint;
        b =
          !f.isEmpty(b) && -1 < f.getDomainFromUrl(b).indexOf("force")
            ? f.addPrefixToURL(b, c, !0)
            : b;
        this.endpoint = b;
        b =
          (null != this.endpoint
            ? this.endpoint
            : k.contentServerUrl + k.chatPage) +
          "?language\x3d" +
          (this.language ? this.language : "");
        f.isEmpty(c) ||
          (b += "\x26proxy\x3d" + c + "\x26proxyKey\x3d" + k.prefixKey);
        b += "\x26org_id\x3d" + k.orgId;
        b += "\x26deployment_id\x3d" + k.deploymentId;
        b += "\x26sid\x3d" + w;
        return (b += "#" + a);
      }
      var c = null,
        c =
          null == this.prechat
            ? b.call(this)
            : this.prechat + "?endpoint\x3d" + encodeURIComponent(b.call(this));
      return (
        k.contentServerUrl +
        k.prechatHandler +
        "?endpoint\x3d" +
        encodeURIComponent(c)
      );
    };
    l.prototype.setLanguage = function (a) {
      this.language = a;
    };
    l.prototype.startChat = function (a) {
      return this.dispatchEvent(l.EVENT.BUTTON_ACCEPTED)
        ? (xa(this.buttonId, a), !0)
        : !1;
    };
    l.prototype.rejectChat = function () {
      return this.dispatchEvent(l.EVENT.BUTTON_REJECTED) ? !0 : !1;
    };
    l.prototype.dispatchEvent = function (a) {
      return ga.hasOwnProperty(this.buttonId)
        ? !1 === ga[this.buttonId].call(this, a)
          ? !1
          : !0
        : !0;
    };
    t.prototype.init = function (a, b) {
      this.buttonId = a;
      this.element = b;
    };
    t.prototype.getId = function () {
      return this.buttonId;
    };
    t.prototype.setState = function (a) {
      f.log(
        "Setting state for button " +
          this.buttonId +
          " to " +
          (a ? "online" : "offline")
      );
      return m[this.buttonId].dispatchEvent(
        a ? l.EVENT.BUTTON_AVAILABLE : l.EVENT.BUTTON_UNAVAILABLE
      )
        ? !0
        : !1;
    };
    ka.prototype = new l();
    S.prototype = new l();
    S.prototype.startChat = function (a, b) {
      if (this.dispatchEvent(l.EVENT.BUTTON_ACCEPTED)) {
        var c = this.buttonId.split("_");
        xa(c[1], a, c[0], b);
        return !0;
      }
      return !1;
    };
    T.prototype = new t();
    T.prototype.setState = function (a) {
      t.prototype.setState.call(this, a) &&
        (this.element.style.display = a ? "" : "none");
    };
    U.prototype = new t();
    U.prototype.setState = function (a) {
      t.prototype.setState.call(this, a) &&
        (this.element.style.display = a ? "none" : "");
    };
    var ha = !1,
      F = null,
      ia = {},
      G = {};
    p.prototype = new l();
    p.RENDERER = {
      Slide: { renderClass: I },
      Fade: { renderClass: J },
      Appear: { renderClass: L },
      Custom: { renderClass: D }
    };
    p.START_POSITION = {
      TopLeft: {
        xPercent: 0,
        xPosition: -1,
        xOffset: -1,
        yPercent: 0,
        yPosition: -1,
        yOffset: -1
      },
      TopLeftTop: {
        xPercent: 0,
        xPosition: 0,
        xOffset: 1,
        yPercent: 0,
        yPosition: -1,
        yOffset: -1
      },
      Top: {
        xPercent: 0.5,
        xPosition: -0.5,
        xOffset: 0,
        yPercent: 0,
        yPosition: -1,
        yOffset: -1
      },
      TopRightTop: {
        xPercent: 1,
        xPosition: -1,
        xOffset: -1,
        yPercent: 0,
        yPosition: -1,
        yOffset: -1
      },
      TopRight: {
        xPercent: 1,
        xPosition: 0,
        xOffset: 1,
        yPercent: 0,
        yPosition: -1,
        yOffset: -1
      },
      TopRightRight: {
        xPercent: 1,
        xPosition: 0,
        xOffset: 1,
        yPercent: 0,
        yPosition: 0,
        yOffset: 1
      },
      Right: {
        xPercent: 1,
        xPosition: 0,
        xOffset: 1,
        yPercent: 0.5,
        yPosition: -0.5,
        yOffset: 0
      },
      BottomRightRight: {
        xPercent: 1,
        xPosition: 0,
        xOffset: 1,
        yPercent: 1,
        yPosition: -1,
        yOffset: -1
      },
      BottomRight: {
        xPercent: 1,
        xPosition: 0,
        xOffset: 1,
        yPercent: 1,
        yPosition: 0,
        yOffset: 1
      },
      BottomRightBottom: {
        xPercent: 1,
        xPosition: -1,
        xOffset: -1,
        yPercent: 1,
        yPosition: 0,
        yOffset: 1
      },
      Bottom: {
        xPercent: 0.5,
        xPosition: -0.5,
        xOffset: 0,
        yPercent: 1,
        yPosition: 0,
        yOffset: 1
      },
      BottomLeftBottom: {
        xPercent: 0,
        xPosition: 0,
        xOffset: 1,
        yPercent: 1,
        yPosition: 0,
        yOffset: 1
      },
      BottomLeft: {
        xPercent: 0,
        xPosition: -1,
        xOffset: -1,
        yPercent: 1,
        yPosition: 0,
        yOffset: 1
      },
      BottomLeftLeft: {
        xPercent: 0,
        xPosition: -1,
        xOffset: -1,
        yPercent: 1,
        yPosition: -1,
        yOffset: -1
      },
      Left: {
        xPercent: 0,
        xPosition: -1,
        xOffset: -1,
        yPercent: 0.5,
        yPosition: -0.5,
        yOffset: 0
      },
      TopLeftLeft: {
        xPercent: 0,
        xPosition: -1,
        xOffset: -1,
        yPercent: 0,
        yPosition: 0,
        yOffset: 1
      }
    };
    p.END_POSITION = {
      TopLeft: { xPercent: 0, xOffset: 1, yPercent: 0, yOffset: 1 },
      Top: { xPercent: 0.5, xOffset: 0, yPercent: 0, yOffset: 1 },
      TopRight: { xPercent: 1, xOffset: -1, yPercent: 0, yOffset: 1 },
      Left: { xPercent: 0, xOffset: 1, yPercent: 0.5, yOffset: 0 },
      Center: { xPercent: 0.5, xOffset: 0, yPercent: 0.5, yOffset: 0 },
      Right: { xPercent: 1, xOffset: -1, yPercent: 0.5, yOffset: 0 },
      BottomLeft: { xPercent: 0, xOffset: 1, yPercent: 1, yOffset: -1 },
      Bottom: { xPercent: 0.5, xOffset: 0, yPercent: 1, yOffset: -1 },
      BottomRight: { xPercent: 1, xOffset: -1, yPercent: 1, yOffset: -1 }
    };
    p.prototype.setRules = function (a, b) {
      if (a && b) {
        for (var c in a) {
          var e = a[c],
            d = null;
          switch (e.type) {
            case n.TYPE.NUMBER_OF_PAGE_VIEWS:
              d = new M(
                e.order,
                this.buttonId,
                A.getPageCount(),
                e.operator,
                parseInt(e.value, 10)
              );
              break;
            case n.TYPE.URL_MATCH:
              d = new M(
                e.order,
                this.buttonId,
                A.getCurrentPage(),
                e.operator,
                e.value
              );
              break;
            case n.TYPE.SECONDS_ON_PAGE:
              d = new N(
                e.order,
                this.buttonId,
                new Date().getTime(),
                e.operator,
                1e3 * parseInt(e.value, 10)
              );
              break;
            case n.TYPE.SECONDS_ON_SITE:
              d = new N(
                e.order,
                this.buttonId,
                parseInt(A.getSessionStart(), 10),
                e.operator,
                1e3 * parseInt(e.value, 10)
              );
              break;
            case n.TYPE.CUSTOM_VARIABLE:
              (d = new V(e.order, this.buttonId, e.name, e.operator, e.value)),
                G.hasOwnProperty(e.name) || (G[e.name] = []),
                G[e.name].push(this.buttonId);
          }
          null != d && this.addRule(d);
        }
        this.filterLogic = b;
        this.ruleTree = E(b);
      }
    };
    p.prototype.setOnlineState = function (a) {
      a ||
        null === this.inviteTimeout ||
        (clearTimeout(this.inviteTimeout), (this.inviteTimeout = null));
      a ||
        null === this.autoRejectTimeout ||
        (clearTimeout(this.autoRejectTimeout), (this.autoRejectTimeout = null));
      l.prototype.setOnlineState.call(this, a);
    };
    p.prototype.isActive = function () {
      return this.active;
    };
    p.prototype.setActive = function (a) {
      this.active = a;
    };
    p.prototype.addTracker = function (a) {
      this.trackers = [];
      l.prototype.addTracker.call(this, a);
    };
    p.prototype.getTracker = function () {
      if (1 != this.trackers.length)
        throw Error("InviteButtons should have exactly 1 tracker");
      return this.trackers[0];
    };
    p.prototype.startChat = function (a) {
      return this.active && l.prototype.startChat.call(this, a)
        ? (this.getTracker().accept(), !0)
        : !1;
    };
    p.prototype.rejectChat = function () {
      return this.active && l.prototype.rejectChat.call(this)
        ? (this.getTracker().reject(), !0)
        : !1;
    };
    p.prototype.trigger = function () {
      if (f.getCookie("liveagent_invite_rejected_" + this.buttonId)) return !1;
      var a = !0;
      null != this.ruleTree &&
        (f.logGroupStart("Invite " + this.buttonId + " Rule Evaluation"),
        f.log("Filter Logic: " + this.filterLogic),
        (a = this.ruleTree.evaluate(this)),
        f.logGroupEnd());
      if (!a && null != this.inviteDelay) {
        var b = this;
        this.inviteTimeout = window.setTimeout(function () {
          b.setOnlineState(!0);
        }, this.inviteDelay);
        this.inviteDelay = null;
      }
      return a;
    };
    p.prototype.addRule = function (a) {
      this.rules[a.getId()] = a;
    };
    p.prototype.getRule = function (a) {
      return this.rules[a];
    };
    p.prototype.getInviteDelay = function () {
      return this.inviteDelay;
    };
    p.prototype.setInviteDelay = function (a) {
      f.log("Setting invite delay to: " + a);
      this.inviteDelay = a;
    };
    p.prototype.setAutoRejectTimeout = function (a) {
      this.autoRejectTimeout = a;
    };
    z.prototype = new t();
    z.prototype.setState = function (a) {
      a &&
      !ha &&
      u(this.buttonId).trigger() &&
      t.prototype.setState.call(this, !0)
        ? ((ha = !0), (F = this.buttonId), this.renderer.render())
        : !a &&
          u(this.buttonId).isActive() &&
          t.prototype.setState.call(this, !1) &&
          ((ha = !1), this.remove(!0));
    };
    z.prototype.renderFinish = function () {
      u(this.buttonId).setActive(!0);
      if (-1 != this.rejectTime) {
        var a = this.buttonId;
        u(this.buttonId).setAutoRejectTimeout(
          window.setTimeout(function () {
            u(a).rejectChat();
          }, 1e3 * this.rejectTime)
        );
      }
      this.renderer.renderFinish();
    };
    z.prototype.accept = function () {
      this.hasInviteAfterAccept ||
        f.setCookie("liveagent_invite_rejected_" + this.buttonId, !0, !1);
      this.remove(!1);
    };
    z.prototype.reject = function () {
      this.hasInviteAfterReject ||
        f.setCookie("liveagent_invite_rejected_" + this.buttonId, !0, !1);
      this.remove(!0);
    };
    z.prototype.remove = function (a) {
      u(this.buttonId).setActive(!1);
      this.renderer.remove(a);
    };
    z.prototype.removeFinish = function () {
      this.renderer.remove(!1);
    };
    r.prototype.init = function (a, b, c, e) {
      window.innerWidth
        ? (this.realWidth = window.innerWidth)
        : document.documentElement && document.documentElement.clientWidth
        ? (this.realWidth = document.documentElement.clientWidth)
        : document.body && (this.realWidth = document.body.clientWidth);
      window.innerHeight
        ? (this.realHeight = window.innerHeight)
        : document.documentElement && document.documentElement.clientHeight
        ? (this.realHeight = document.documentElement.clientHeight)
        : document.body && (this.realHeight = document.body.clientHeight);
      this.offset = 25;
      this.buttonId = a;
      this.animationPrefix = f.getCssAnimation(b);
      this.element = b;
      this.element.style.position =
        null !== this.animationPrefix ? "fixed" : "absolute";
      this.element.style.left = "-1000px";
      this.element.style.top = "-1000px";
      this.element.style.zIndex = "10000";
      this.element.style.display = "";
      this.width = this.element.offsetWidth;
      this.height = this.element.offsetHeight;
      this.startPosition = c;
      this.endPosition = e;
    };
    r.prototype.render = function () {
      this.element.style.display = "";
    };
    r.prototype.renderFinish = function () {};
    r.prototype.remove = function (a) {
      this.element.style.left = "-1000px";
      this.element.style.top = "-1000px";
    };
    r.prototype.addRenderListeners = function () {
      var a = this.buttonId,
        b = "AnimationIteration",
        c = "AnimationEnd";
      "" == this.animationPrefix
        ? ((b = b.toLowerCase()), (c = c.toLowerCase()))
        : ((b = this.animationPrefix + b), (c = this.animationPrefix + c));
      f.addEventListener(this.element, b, function () {
        C(a).renderFinish();
      });
      f.addEventListener(this.element, c, function () {
        C(a).removeFinish();
      });
    };
    I.prototype = new r();
    I.prototype.render = function () {
      r.prototype.addRenderListeners.call(this);
      var a =
          this.width * this.startPosition.xPosition +
          this.offset * this.startPosition.xOffset,
        b =
          this.height * this.startPosition.yPosition +
          this.offset * this.startPosition.yOffset,
        c =
          this.width * this.endPosition.xPercent * -1 +
          this.offset * this.endPosition.xOffset,
        e =
          this.height * this.endPosition.yPercent * -1 +
          this.offset * this.endPosition.yOffset,
        d = "";
      "" !== this.animationPrefix && (d = "-" + this.animationPrefix + "-");
      var g = document.createElement("style");
      g.innerHTML =
        "@" +
        d +
        "keyframes slide" +
        this.buttonId +
        "{from { margin-left: " +
        a +
        "px; margin-top: " +
        b +
        "px; left: " +
        100 * this.startPosition.xPercent +
        "%; top: " +
        100 * this.startPosition.yPercent +
        "%; }to { margin-left: " +
        c +
        "px; margin-top: " +
        e +
        "px; left: " +
        100 * this.endPosition.xPercent +
        "%; top: " +
        100 * this.endPosition.yPercent +
        "%; }}";
      document.getElementsByTagName("head")[0].appendChild(g);
      this.element.style[d + "animation-name"] = "slide" + this.buttonId;
      this.element.style[d + "animation-duration"] = "1s";
      this.element.style[d + "animation-iteration-count"] = "2";
      this.element.style[d + "animation-direction"] = "alternate";
      this.element.style[d + "animation-timing-function"] = "ease-in-out";
      this.element.style.setProperty(
        d + "animation-name",
        "slide" + this.buttonId,
        ""
      );
      this.element.style.setProperty(d + "animation-duration", "1s", "");
      this.element.style.setProperty(d + "animation-iteration-count", "2", "");
      this.element.style.setProperty(
        d + "animation-direction",
        "alternate",
        ""
      );
      this.element.style.setProperty(
        d + "animation-timing-function",
        "ease-in-out",
        ""
      );
      r.prototype.render.call(this);
    };
    I.prototype.renderFinish = function () {
      var a = "";
      "" !== this.animationPrefix && (a = "-" + this.animationPrefix + "-");
      this.element.style[a + "animation-play-state"] = "paused";
      this.element.style.setProperty(a + "animation-play-state", "paused", "");
    };
    I.prototype.remove = function (a) {
      var b = "";
      "" !== this.animationPrefix && (b = "-" + this.animationPrefix + "-");
      a
        ? ((this.element.style[b + "animation-play-state"] = "running"),
          this.element.style.setProperty(
            b + "animation-play-state",
            "running",
            ""
          ))
        : ((this.element.style[b + "animation-name"] = ""),
          this.element.style.setProperty(b + "animation-name", "", ""),
          r.prototype.remove.call(this, a));
    };
    J.prototype = new r();
    J.prototype.render = function () {
      r.prototype.addRenderListeners.call(this);
      var a = "";
      "" !== this.animationPrefix && (a = "-" + this.animationPrefix + "-");
      var b = document.createElement("style");
      b.innerHTML =
        "@" +
        a +
        "keyframes fade" +
        this.buttonId +
        "{from { opacity: 0; }to { opacity: 1; }}";
      document.getElementsByTagName("head")[0].appendChild(b);
      this.element.style[a + "animation-name"] = "fade" + this.buttonId;
      this.element.style[a + "animation-duration"] = "1s";
      this.element.style[a + "animation-iteration-count"] = "2";
      this.element.style[a + "animation-direction"] = "alternate";
      this.element.style[a + "animation-timing-function"] = "ease-in-out";
      this.element.style.setProperty(
        a + "animation-name",
        "fade" + this.buttonId,
        ""
      );
      this.element.style.setProperty(a + "animation-duration", "1s", "");
      this.element.style.setProperty(a + "animation-iteration-count", "2", "");
      this.element.style.setProperty(
        a + "animation-direction",
        "alternate",
        ""
      );
      this.element.style.setProperty(
        a + "animation-timing-function",
        "ease-in-out",
        ""
      );
      this.element.style.marginLeft =
        this.width * this.endPosition.xPercent * -1 +
        this.offset * this.endPosition.xOffset +
        "px";
      this.element.style.left = 100 * this.endPosition.xPercent + "%";
      this.element.style.marginTop =
        this.height * this.endPosition.yPercent * -1 +
        this.offset * this.endPosition.yOffset +
        "px";
      this.element.style.top = 100 * this.endPosition.yPercent + "%";
      r.prototype.render.call(this);
    };
    J.prototype.renderFinish = function () {
      var a = "";
      "" !== this.animationPrefix && (a = "-" + this.animationPrefix + "-");
      this.element.style[a + "animation-play-state"] = "paused";
      this.element.style.setProperty(a + "animation-play-state", "paused", "");
    };
    J.prototype.remove = function (a) {
      var b = "";
      "" !== this.animationPrefix && (b = "-" + this.animationPrefix + "-");
      a
        ? ((this.element.style[b + "animation-play-state"] = "running"),
          this.element.style.setProperty(
            b + "animation-play-state",
            "running",
            ""
          ),
          (this.element.style.opacity = 0))
        : ((this.element.style[b + "animation-name"] = ""),
          this.element.style.setProperty(b + "animation-name", "", ""),
          r.prototype.remove.call(this, a));
    };
    L.prototype = new r();
    L.prototype.render = function () {
      this.element.style.marginLeft =
        this.width * this.endPosition.xPercent * -1 +
        this.offset * this.endPosition.xOffset +
        "px";
      this.element.style.left = 100 * this.endPosition.xPercent + "%";
      this.element.style.marginTop =
        this.height * this.endPosition.yPercent * -1 +
        this.offset * this.endPosition.yOffset +
        "px";
      this.element.style.top = 100 * this.endPosition.yPercent + "%";
      r.prototype.render.call(this);
      C(this.buttonId).renderFinish();
    };
    L.prototype.remove = function (a) {
      a ? C(this.buttonId).removeFinish() : r.prototype.remove.call(this, a);
    };
    D.prototype = new r();
    D.prototype.render = function () {
      C(this.buttonId).renderFinish();
    };
    D.prototype.renderFinish = function () {};
    D.prototype.remove = function (a) {
      a && C(this.buttonId).removeFinish();
    };
    n.TYPE = {
      NUMBER_OF_PAGE_VIEWS: "NUMBER_OF_PAGE_VIEWS",
      URL_MATCH: "URL_MATCH",
      SECONDS_ON_PAGE: "SECONDS_ON_PAGE",
      SECONDS_ON_SITE: "SECONDS_ON_SITE",
      CUSTOM_VARIABLE: "CUSTOM_VARIABLE"
    };
    n.OPERATOR = {
      EQUALS: "EQUALS",
      NOT_EQUAL: "NOT_EQUAL",
      START_WITH: "START_WITH",
      CONTAINS: "CONTAINS",
      NOT_CONTAIN: "NOT_CONTAIN",
      LESS_THAN: "LESS_THAN",
      GREATER_THAN: "GREATER_THAN",
      LESS_OR_EQUAL: "LESS_OR_EQUAL",
      GREATER_OR_EQUAL: "GREATER_OR_EQUAL"
    };
    n.prototype.init = function (a, b, c, e, d) {
      this.ruleId = a;
      this.buttonId = b;
      this.compareFrom = c;
      this.operator = e;
      this.compareTo = d;
    };
    n.prototype.getId = function () {
      return this.ruleId;
    };
    n.prototype.evaluate = function (a, b) {
      switch (this.operator) {
        case n.OPERATOR.EQUALS:
          return f.log("Evaluate: " + a + " \x3d\x3d " + b), a == b;
        case n.OPERATOR.NOT_EQUAL:
          return f.log("Evaluate: " + a + " !\x3d " + b), a != b;
        case n.OPERATOR.START_WITH:
          return (
            f.log("Evaluate: " + a + " indexOf " + b + " \x3d\x3d 0"),
            0 == a.indexOf(b)
          );
        case n.OPERATOR.CONTAINS:
          return (
            f.log("Evaluate: " + a + " indexOf " + b + " !\x3d -1"),
            -1 != a.indexOf(b)
          );
        case n.OPERATOR.NOT_CONTAIN:
          return (
            f.log("Evaluate: " + a + " indexOf " + b + " \x3d\x3d -1"),
            -1 == a.indexOf(b)
          );
        case n.OPERATOR.LESS_THAN:
          return (
            f.log("Evaluate: " + parseFloat(a) + " \x3c " + parseFloat(b)),
            parseFloat(a) < parseFloat(b)
          );
        case n.OPERATOR.GREATER_THAN:
          return (
            f.log("Evaluate: " + parseFloat(a) + " \x3e " + parseFloat(b)),
            parseFloat(a) > parseFloat(b)
          );
        case n.OPERATOR.LESS_OR_EQUAL:
          return (
            f.log("Evaluate: " + parseFloat(a) + " \x3c\x3d " + parseFloat(b)),
            parseFloat(a) <= parseFloat(b)
          );
        case n.OPERATOR.GREATER_OR_EQUAL:
          return (
            f.log("Evaluate: " + parseFloat(a) + " \x3e\x3d " + parseFloat(b)),
            parseFloat(a) >= parseFloat(b)
          );
      }
    };
    M.prototype = new n();
    M.prototype.evaluate = function () {
      f.log("Evaluating StandardInviteRule");
      return n.prototype.evaluate.call(this, this.compareFrom, this.compareTo);
    };
    N.prototype = new n();
    N.prototype.evaluate = function () {
      f.log("Evaluating TimerInviteRule");
      var a = new Date().getTime() - this.compareFrom,
        b = n.prototype.evaluate.call(this, a, this.compareTo);
      !b &&
        a <= this.compareTo &&
        ((a = this.compareTo - a),
        (null == u(this.buttonId).getInviteDelay() ||
          a < u(this.buttonId).getInviteDelay()) &&
          u(this.buttonId).setInviteDelay(a));
      return b;
    };
    V.prototype = new n();
    V.prototype.evaluate = function () {
      if (ia.hasOwnProperty(this.compareFrom))
        return (
          f.log("Evaluating CustomInviteRule"),
          n.prototype.evaluate.call(
            this,
            ia[this.compareFrom].toString(),
            this.compareTo
          )
        );
      f.log(
        "CustomInviteRule evaluation failed due to missing custom variable"
      );
      return !1;
    };
    var ma = 0;
    y.prototype.init = function (a, b) {
      this.left = a;
      this.right = b;
    };
    y.prototype.evaluate = function (a) {
      return !1;
    };
    Z.prototype = new y();
    Z.prototype.evaluate = function (a) {
      f.log("Evaluating Atom Node: " + this.ruleId);
      return a.getRule(this.ruleId).evaluate();
    };
    W.prototype = new y();
    W.prototype.evaluate = function (a) {
      f.logGroupStart("Evaluating And Node");
      a = this.left.evaluate(a) && this.right.evaluate(a);
      f.logGroupEnd();
      return a;
    };
    X.prototype = new y();
    X.prototype.evaluate = function (a) {
      f.logGroupStart("Evaluating Or Node");
      a = this.left.evaluate(a) || this.right.evaluate(a);
      f.logGroupEnd();
      return a;
    };
    Y.prototype = new y();
    Y.prototype.evaluate = function (a) {
      f.logGroupStart("Evaluating Not Node");
      a = !this.left.evaluate(a);
      f.logGroupEnd();
      return a;
    };
    na.prototype.toJSON = function () {
      return {
        label: this.getLabel(),
        value: this.getValue(),
        displayToAgent: this.getDisplayToAgent(),
        entityMaps: this.getMapper().getEntityMaps(),
        transcriptFields: this.getMapper().getTranscriptFields(),
        doKnowledgeSearch: this.getDoKnowledgeSearch()
      };
    };
    aa.prototype.map = function (a, b, c, e, d) {
      "undefined" == typeof c && (c = !0);
      "undefined" == typeof e && (e = !0);
      "undefined" == typeof d && (d = !0);
      this.getEntityMaps().push(new oa(a, b, c, e, d));
    };
    aa.prototype.saveToTranscript = function (a) {
      this.getTranscriptFields().push(a);
    };
    oa.prototype.toJSON = function () {
      return {
        entityName: this.getEntityName(),
        fieldName: this.getFieldName(),
        fastFill: this.getFastFill(),
        autoQuery: this.getAutoQuery(),
        exactMatch: this.getExactMatch()
      };
    };
    var H = {};
    h._ = H;
    H.handlePing = function (a) {
      q.connection.handlePing(a);
    };
    H.error = function (a) {
      a
        ? f.log("Server Error: " + a)
        : f.log("Server responded with an error.");
      ca();
    };
    H.warning = function (a) {
      a
        ? f.log("Server Warning: " + a)
        : f.log("Server sent an anoymous warning.");
    };
    H.setNewPtid = function (a) {
      v.setPermanentId(a);
    };
    H.clearStorage = function () {
      A.clear();
    };
    h.init = function (a, b, c) {
      if ("string" != typeof a) throw Error("The url to init must be strings");
      if (!f.isOrganizationId(c))
        throw Error("Invalid OrganizationId Parameter Value: " + c);
      if (!f.isDeploymentId(b))
        throw Error("Invalid DeploymentId Parameter Value: " + b);
      k.url = a;
      k.deploymentId = b;
      k.orgId = c;
      f.log("System Initialized. Waiting for the DOM to be ready");
      "complete" === document.readyState
        ? setTimeout(O, 1)
        : document.addEventListener
        ? (document.addEventListener("DOMContentLoaded", O, !1),
          window.addEventListener("load", O, !1))
        : window.attachEvent
        ? window.attachEvent("onload", O)
        : f.log("No available event model. Exiting.");
    };
    h.getSid = function () {
      return w;
    };
    h.enableLogging = function () {
      R = !0;
    };
    h.setLocation = function (a) {};
    h.setChatWindowWidth = function (a) {
      k.chatWindowWidth = a;
    };
    h.setChatWindowHeight = function (a) {
      k.chatWindowHeight = a;
    };
    h.disconnect = function () {
      ca();
    };
    h.startChat = function (a, b, c) {
      (b ? K(a, b) : m[a]).startChat(
        "liveagent" + Math.round(1e5 * Math.random()) + new Date().getTime(),
        c
      );
    };
    h.startChatWithWindow = function (a, b, c, e) {
      (c ? K(a, c) : m[a]).startChat(b, e);
    };
    h.rejectChat = function (a) {
      m[a].rejectChat();
    };
    h.showWhenOnline = function (a, b, c) {
      if (q.connection.isRunning())
        throw Error("You cannot add a button after page initialization.");
      a = c ? K(a, c) : la(a);
      a.addTracker(new T(a.buttonId, b));
    };
    h.showWhenOffline = function (a, b, c) {
      if (q.connection.isRunning())
        throw Error("You cannot add a button after page initialization.");
      a = c ? K(a, c) : la(a);
      a.addTracker(new U(a.buttonId, b));
    };
    h.addCustomDetail = function (a, b, c) {
      if (q.connection.isRunning())
        throw Error("You cannot add a detail after page initialization.");
      if (
        "undefined" == typeof a ||
        "undefined" == typeof b ||
        null === a ||
        null === b
      )
        throw Error("CustomDetail contains null value");
      var e = new na(a, b, c);
      ya.push(e);
      var d = {
        map: function (a, b, c, f, k) {
          if (
            "undefined" == typeof a ||
            null === a ||
            "undefined" == typeof b ||
            null === b ||
            null === c ||
            null === f ||
            null === k
          )
            throw Error("CustomDetail.map contains null value");
          e.getMapper().map(a, b, c, f, k);
          return d;
        },
        saveToTranscript: function (a) {
          if ("undefined" == typeof a || null === a)
            throw Error("CustomDetail.saveToTranscript contains null value");
          e.getMapper().saveToTranscript(a);
          return d;
        },
        doKnowledgeSearch: function () {
          e.setDoKnowledgeSearch();
          return d;
        }
      };
      return d;
    };
    h.setName = function (a) {
      if (q.connection.isRunning())
        throw Error("You cannot set the name after page initialization.");
      da = a;
    };
    h.addButtonEventHandler = function (a, b) {
      "function" == typeof b && (ga[a] = b);
    };
    h.BUTTON_EVENT = l.EVENT;
    h.setCustomVariable = function (a, b) {
      ia[a] = b;
      if (G.hasOwnProperty(a))
        for (var c = 0; c < G[a].length; c++) {
          var e = u(G[a][c]);
          e.getOnlineState() && e.setOnlineState(!0);
        }
    };
    h.findOrCreate = function (a) {
      if (q.connection.isRunning())
        throw Error("You cannot find or create after page initialization.");
      var b = new pa(a);
      za.push(b);
      var c = {
        map: function (a, d, g, f, k) {
          b.getEntityMapper().map(a, d, g, f, k);
          return c;
        },
        saveToTranscript: function (a) {
          b.setSaveTranscript(a);
          return c;
        },
        showOnCreate: function () {
          b.setShowOnCreate(!0);
          return c;
        },
        linkToEntity: function (a, d) {
          if (ja.hasOwnProperty(a) && ja[a] == b.getEntityName())
            return (
              ea(
                "Warning: Recursive links detected, skip link " +
                  b.getEntityName() +
                  " to " +
                  a
              ),
              c
            );
          b.setLinkToEntityName(a);
          b.setLinkToEntityField(d);
          ja[b.getEntityName()] = a;
          return c;
        }
      };
      return c;
    };
    h.addURLPrefix = function (a) {
      if (q.connection.isRunning())
        throw Error("You cannot set a URL Prefix after page initialization.");
      if ("string" != typeof a)
        throw Error("The parameter to addURLPrefix must be a string");
      k.url = f.addPrefixToURL(k.url, a, !0);
      k.urlPrefix = a;
    };
    h.enableEstimatedWaitTime = function () {
      k.needEstimatedWaitTime = !0;
    };
    h.getEstimatedWaitTime = function (a) {
      return (a = m[a]) ? a.estimatedWaitTime : -1;
    };
    var q = {
      VisitorMessage: { ERROR: "Error", WARNING: "Warning" },
      SystemMessage: {
        ASYNC_RESULT: "AsyncResult",
        SWITCH_SERVER: "SwitchServer"
      }
    };
    (function () {
      var a = null,
        b = !1,
        c = null,
        e = null,
        d = {};
      (function () {
        d.send = function (b, f) {
          if (null !== c)
            d.onError.call(
              window,
              "Did not handle response before sending another message"
            );
          else {
            "undefined" == typeof f && (f = {});
            var h = "Visitor",
              l = "",
              m = !1;
            1 < b.length
              ? ((h = "System"), (l = "MultiNoun"), (f.nouns = ""), (m = !0))
              : (l = b[0].getName());
            h = k.url + "/rest/" + h + "/" + l + ".jsonp?";
            for (l = 0; l < b.length; l++) {
              m && (f.nouns += b[l].getName() + ",");
              f[b[l].getName() + ".prefix"] = "Visitor";
              for (var n in b[l].getData())
                b[l].getData().hasOwnProperty(n) &&
                  (f[b[l].getName() + "." + n] = b[l].getData()[n]);
            }
            m && (f.nouns = f.nouns.substr(0, f.nouns.length - 1));
            for (var p in f)
              f.hasOwnProperty(p) && (h += p + "\x3d" + f[p] + "\x26");
            h += "callback\x3d" + a;
            h += "\x26deployment_id\x3d" + k.deploymentId;
            h += "\x26org_id\x3d" + k.orgId;
            h += "\x26version\x3d50";
            m = document.createElement("script");
            m.type = "text/javascript";
            m.src = h;
            c = document.body.appendChild(m);
            e = window.setTimeout(function () {
              d.onError.call(window, "Server failed to respond.");
            }, k.pingTimeout);
          }
        };
        d.handlePing = function (a) {
          e && (clearTimeout(e), (e = null));
          b = !0;
          a = a.messages;
          for (var c = 0; c < a.length; c++)
            d.messageHandler.call(window, a[c].type, a[c].message);
          d.onSuccess.call(window);
          d.removePingScript();
        };
        d.messageHandler = function (a, b) {};
        d.onSuccess = function () {};
        d.onError = function (a) {};
        d.isRunning = function () {
          return b;
        };
        d.setIsRunning = function (a) {
          b = a;
        };
        d.setCallback = function (b) {
          a = b;
        };
        d.removePingScript = function () {
          null !== c && (document.body.removeChild(c), (c = null));
        };
      })();
      q.connection = d;
      q.Noun = function (a, b) {
        this.getName = function () {
          return a;
        };
        this.getData = function () {
          return b;
        };
      };
    })();
    pa.prototype.toJSON = function () {
      return {
        entityName: this.getEntityName(),
        saveToTranscript: this.getSaveTranscript(),
        showOnCreate: this.getShowOnCreate(),
        linkToEntityName: this.getLinkToEntityName(),
        linkToEntityField: this.getLinkToEntityField(),
        entityFieldsMaps: this.getEntityMapper().getEntityFieldsMaps()
      };
    };
    qa.prototype.map = function (a, b, c, e, d) {
      "undefined" == typeof c && (c = !0);
      "undefined" == typeof e && (e = !0);
      "undefined" == typeof d && (d = !0);
      this.getEntityFieldsMaps().push(new ra(a, b, c, e, d));
    };
    ra.prototype.toJSON = function () {
      return {
        fieldName: this.getFieldName(),
        label: this.getLabel(),
        doFind: this.getDoFind(),
        isExactMatch: this.getIsExactMatch(),
        doCreate: this.getDoCreate()
      };
    };
    var w = f.getCookie("liveagent_sid"),
      ba = f.getCookie("liveagent_chatted"),
      sa = !1,
      R = !1,
      m = {},
      ya = [],
      za = [],
      da = null,
      ga = {},
      P = null,
      ja = {},
      Q = !1,
      k = {
        url: null,
        deploymentId: null,
        orgId: null,
        pingRate: 5e4,
        pingTimeout: 5e3,
        chatWindowWidth: 482,
        chatWindowHeight: 450,
        contentServerUrl: null,
        chatPage: "/s/chat",
        prechatHandler: "/s/prechatVisitor",
        needEstimatedWaitTime: !1
      };
    q.connection.messageHandler = function (a, b) {
      switch (a) {
        case "VisitorId":
          b.sessionId &&
            (f.log("Received new session ID"),
            (w = b.sessionId),
            (document.cookie =
              "liveagent_sid\x3d" + encodeURIComponent(w) + ";path\x3d/;"),
            null != v.getVisitCount() && v.setVisitCount(v.getVisitCount() + 1),
            v.getPermanentId() || v.setPermanentId(w));
          break;
        case "Settings":
          A.init();
          f.log("Ping rate set to " + b.pingRate + "ms");
          k.pingRate = b.pingRate;
          k.contentServerUrl = b.contentServerUrl;
          k.prefixKey = b.prefixKey;
          for (var c = 0; c < b.buttons.length; c++)
            switch (b.buttons[c].type) {
              case "ToAgent":
              case "Standard":
                var e = b.buttons[c],
                  d = m[e.id];
                d && wa(d, e);
                break;
              case "Invite":
                var e = b.buttons[c],
                  g = null,
                  g = e.inviteImageUrl
                    ? Ca(
                        e.id,
                        e.inviteImageUrl,
                        e.inviteImageWidth,
                        e.inviteImageHeight
                      )
                    : document.getElementById(
                        "liveagent_invite_button_" + e.id
                      );
                null == g
                  ? ea(
                      "Warning: Button " +
                        e.id +
                        " disabled because HTML element was not found"
                    )
                  : ((d = u(e.id)),
                    d.addTracker(
                      new z(
                        e.id,
                        g,
                        e.inviteRenderer,
                        e.inviteStartPosition,
                        e.inviteEndPosition,
                        e.hasInviteAfterAccept,
                        e.hasInviteAfterReject,
                        e.inviteRejectTime
                      )
                    ),
                    (g = f.jsonDecode(e.inviteRules)),
                    d.setRules(g.rules, g.filter),
                    wa(d, e));
            }
          break;
        case "Availability":
          c = {};
          for (e = 0; e < b.results.length; e++)
            (d = m[b.results[e].id]) &&
              (c[b.results[e].id] = {
                button: d,
                isAvailable: b.results[e].isAvailable,
                estimatedWaitTime: b.results[e].estimatedWaitTime
              });
          null != F &&
            c.hasOwnProperty(F) &&
            (c[F].button.setOnlineState(c[F].isAvailable), delete c[F]);
          for (g in c)
            c.hasOwnProperty(g) &&
              (c[g].button.setOnlineState(c[g].isAvailable),
              c[g].button.setEstimatedWaitTime(c[g].estimatedWaitTime));
          break;
        case q.VisitorMessage.WARNING:
          ea(b.text);
          break;
        case q.VisitorMessage.ERROR:
          Aa(b.text);
          ca();
          break;
        case q.SystemMessage.SWITCH_SERVER:
          c = b.newUrl;
          if ("string" === typeof c)
            (k.url = c),
              f.log(
                "Received updated LiveAgent server url: " +
                  c +
                  "! Consider updating this site's deployment code."
              );
          else throw Error("Trying to set invalid LiveAgent server url: " + c);
          Q = !0;
      }
    };
    q.connection.onSuccess = function () {
      va();
    };
    q.connection.onError = function (a) {
      Aa(a);
      q.connection.removePingScript();
      va();
    };
  }
})();
